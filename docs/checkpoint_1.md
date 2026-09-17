# Checkpoint 1 — hand-wiring byte/halfword access and the multiply family

Reference implementation: `debug_armv4t_2.circ`  
Destination for the user's hand wiring: `armv4t_2.circ`  
Reference measurement date: 2026-09-02

The comparison used these exact file hashes:

```text
armv4t_2.circ
7e12411be43b1cff74707ac578c5ca90e42738b086614e1edff1b2727c65b69b

debug_armv4t_2.circ
6237cc61f303cbfbada08ba82bcac0f40ce084c443b94976193eaf96918bb27e
```

If either file changes, the signal names and equations remain useful, but rerun
the structural comparison before assuming the list is still a literal delta.

## Purpose and safety rule

This is the component-by-component migration guide that the two architecture
documents intentionally did not provide. It describes how to reproduce the
verified debug behavior by hand in Logisim Evolution.

The protected master circuits must not be edited by an automated agent:

- `armv4t.circ` is read-only;
- `armv4t_2.circ` is read-only to Codex/Claude and is wired only by the user;
- `debug_armv4t_2.circ` is the tested reference/playground.

This guide deliberately avoids screen coordinates. Logisim does not expose the
mouse position as a useful design identifier, and coordinates become invalid as
soon as the layout moves. Every connection is described using:

1. the subcircuit name;
2. an existing pin, tunnel, or signal label;
3. a logical name assigned to each new component;
4. the component's port role, such as `in0`, `in1`, `sel`, `out`, `a`, `b`, or
   `carry out`.

When a Logisim component cannot display a convenient component label, place a
Text annotation beside it using the logical name in this document. Put matching
Tunnel components on its signal nets. The tunnel label is the electrical name;
the nearby Text label is the human-readable component name.

## What your current circuit already has

A structural comparison of the live `armv4t_2.circ` against the verified debug
copy shows that the master already contains:

- the reorganized `stage_IF`, `stage_ID`, `stage_EX`, `stage_MEM`, and
  `stage_WB` interfaces;
- `stage_ID.is_hwxfer` and the `IS_HWXFER` path through `main`;
- the short-multiply decode outputs `is_mult`, `is_long_mul`, and
  `mul_acc_value`;
- the register-read routing needed to present `Rm`, `Rs`, and the accumulate
  operand;
- the ordinary word load/store machinery;
- both register-file write ports in `stage_ID`.

The verified debug copy adds:

- the actual byte-enable and subword datapath in `stage_MEM`;
- three long-multiply controls in `stage_ID`;
- short and long multiply arithmetic in `stage_EX`;
- the cross-stage multiply tunnels in `main`;
- secondary-write-port arbitration in `main`.

`stage_WB` needs no change for this checkpoint.

## Naming rule used below

Connections use this form:

```text
SOURCE_SIGNAL -> COMPONENT_NAME.port
COMPONENT_NAME.out -> DESTINATION_SIGNAL
```

For a two-input multiplexer:

```text
in0 is selected when sel=0
in1 is selected when sel=1
```

For a four-input multiplexer:

```text
in0, in1, in2, in3 correspond to sel=00, 01, 10, 11
```

Use the exact capitalization shown for tunnel labels. Two tunnels are connected
only when their labels and widths match exactly.

---

# Part I — byte and halfword transfers

## MEM-A — identify and name the existing signals

Open `stage_MEM`. Do not add logic yet. Locate the existing sources and attach
or verify these tunnel labels:

| Tunnel name | Width | Attach to |
|---|---:|---|
| `IS_HWXFER` | 1 | input pin `is_hwxfer` |
| `MEM_B` | 1 | input pin or existing instruction control `B` |
| `SH_TYPE` | 2 | input pin `shift_type` |
| `RD_B_FULL` | 32 | input pin `rd_b` |
| `RAM_DATA` | 32 | data output of the RAM named `DATA_RAM` |
| `BASE_LOAD` | 32 | existing ROM-versus-RAM load selection result |

The signal called `B` has two meanings depending on the instruction class:

- ordinary `LDRB`/`STRB`: it means byte transfer;
- extra load/store: instruction bit 22 means immediate versus register offset.

`MEM_B` is used for byte-lane behavior only when `IS_HWXFER=0`.

## MEM-B — extract the byte-address lane bits

Find the existing splitter that converts the calculated byte address into the
word address used by `DATA_RAM`. Tap the address **before** bits 1 and 0 are
discarded.

Create:

```text
ADDR_LO = calculated_byte_address[1:0]
ADDR1   = calculated_byte_address[1]
```

Use a 2-bit tunnel named `ADDR_LO` and a 1-bit tunnel named `ADDR1`.

Do not take these bits from the RAM address input. The RAM address is already a
word index, so its low bits are original address bits 3 and 2, not 1 and 0.

Checkpoint observation:

```text
byte address 0x1100 -> ADDR_LO=00, ADDR1=0
byte address 0x1101 -> ADDR_LO=01, ADDR1=0
byte address 0x1102 -> ADDR_LO=10, ADDR1=1
byte address 0x1103 -> ADDR_LO=11, ADDR1=1
```

## MEM-C — enable the RAM byte-enable ports

Select `DATA_RAM` and enable its four byte-enable inputs. Keep:

- data width: 32;
- address width: the current value;
- separate load/store data ports as currently configured;
- asynchronous read behavior used by the existing CPU;
- clock and write-enable behavior unchanged.

After enabling byte enables, Logisim changes the physical RAM symbol and may
move the clock, data, and control pins. Reconnect by the port names/tooltips, not
by remembering where the old pins were.

The four byte enables mean:

```text
BE0 -> bits  7:0
BE1 -> bits 15:8
BE2 -> bits 23:16
BE3 -> bits 31:24
```

Do not continue while the RAM has red or orange width-error wires.

## MEM-D — build the byte-enable mask

### Components

Place these components and annotate them with these logical names:

| Logical name | Component | Attributes |
|---|---|---|
| `BYTE_MASK_MUX` | Multiplexer | data width 4, select width 2 |
| `HALF_MASK_MUX` | Multiplexer | data width 4, select width 1 |
| `ORD_MASK_MUX` | Multiplexer | data width 4, select width 1 |
| `FINAL_MASK_MUX` | Multiplexer | data width 4, select width 1 |
| `MASK_SPLIT` | Splitter | incoming width 4, fan-out 4, one bit per fan |

Place seven 4-bit constants:

```text
BYTE0_MASK = 0x1
BYTE1_MASK = 0x2
BYTE2_MASK = 0x4
BYTE3_MASK = 0x8
HALF0_MASK = 0x3
HALF1_MASK = 0xC
WORD_MASK  = 0xF
```

### Wiring

```text
BYTE0_MASK -> BYTE_MASK_MUX.in0
BYTE1_MASK -> BYTE_MASK_MUX.in1
BYTE2_MASK -> BYTE_MASK_MUX.in2
BYTE3_MASK -> BYTE_MASK_MUX.in3
ADDR_LO    -> BYTE_MASK_MUX.sel

HALF0_MASK -> HALF_MASK_MUX.in0
HALF1_MASK -> HALF_MASK_MUX.in1
ADDR1      -> HALF_MASK_MUX.sel

WORD_MASK         -> ORD_MASK_MUX.in0
BYTE_MASK_MUX.out -> ORD_MASK_MUX.in1
MEM_B             -> ORD_MASK_MUX.sel

ORD_MASK_MUX.out  -> FINAL_MASK_MUX.in0
HALF_MASK_MUX.out -> FINAL_MASK_MUX.in1
IS_HWXFER         -> FINAL_MASK_MUX.sel

FINAL_MASK_MUX.out -> MASK_SPLIT.combined
MASK_SPLIT.bit0    -> DATA_RAM.BE0
MASK_SPLIT.bit1    -> DATA_RAM.BE1
MASK_SPLIT.bit2    -> DATA_RAM.BE2
MASK_SPLIT.bit3    -> DATA_RAM.BE3
```

This creates the exact mask equations:

```text
ordinary word     -> 1111
ordinary byte +0  -> 0001
ordinary byte +1  -> 0010
ordinary byte +2  -> 0100
ordinary byte +3  -> 1000
halfword low      -> 0011
halfword high     -> 1100
```

## MEM-E — build deterministic store-data replication

The debug circuit contains old nets named `BYTE_REP_OLD` and `HALF_REP_OLD`.
They are unused remnants of a splitter/buffer experiment. Do **not** copy those
blocks. Build only the deterministic fixed-shift version below.

### Extract the source subwords

Use splitters on `RD_B_FULL` to create:

```text
STORE_BYTE = RD_B_FULL[7:0]
STORE_HALF = RD_B_FULL[15:0]
```

### Replicate the byte

Place:

- one zero-extending Bit Extender, input 8 and output 32;
- three 32-bit Shifters configured for logical left shift;
- shift-distance constants 8, 16, and 24, each width 5;
- one 32-bit OR gate with four inputs.

Wire:

```text
STORE_BYTE -> BYTE_ZERO_EXT.in
BYTE_ZERO_EXT.out -> BYTE_Z

BYTE_Z -> BYTE_SHIFT8.data
8      -> BYTE_SHIFT8.distance

BYTE_Z -> BYTE_SHIFT16.data
16     -> BYTE_SHIFT16.distance

BYTE_Z -> BYTE_SHIFT24.data
24     -> BYTE_SHIFT24.distance

BYTE_Z            -> BYTE_REP_OR.in0
BYTE_SHIFT8.out    -> BYTE_REP_OR.in1
BYTE_SHIFT16.out   -> BYTE_REP_OR.in2
BYTE_SHIFT24.out   -> BYTE_REP_OR.in3
BYTE_REP_OR.out    -> BYTE_REP
```

The resulting value is:

```text
BYTE_REP = b | (b << 8) | (b << 16) | (b << 24)
```

### Replicate the halfword

Place:

- one zero-extending Bit Extender, input 16 and output 32;
- one 32-bit logical-left Shifter;
- one width-5 constant with value 16;
- one 32-bit OR gate with two inputs.

Wire:

```text
STORE_HALF -> HALF_ZERO_EXT.in
HALF_ZERO_EXT.out -> HALF_Z

HALF_Z -> HALF_SHIFT16.data
16     -> HALF_SHIFT16.distance

HALF_Z           -> HALF_REP_OR.in0
HALF_SHIFT16.out -> HALF_REP_OR.in1
HALF_REP_OR.out  -> HALF_REP
```

The resulting value is:

```text
HALF_REP = h | (h << 16)
```

## MEM-F — select the RAM store-data bus

Place two 32-bit, one-select-bit multiplexers:

| Logical name | Purpose |
|---|---|
| `ORD_STORE_MUX` | choose ordinary word versus byte data |
| `FINAL_STORE_MUX` | choose ordinary versus halfword data |

Wire:

```text
RD_B_FULL        -> ORD_STORE_MUX.in0
BYTE_REP         -> ORD_STORE_MUX.in1
MEM_B            -> ORD_STORE_MUX.sel
ORD_STORE_MUX.out -> ORD_STORE_DATA

ORD_STORE_DATA   -> FINAL_STORE_MUX.in0
HALF_REP         -> FINAL_STORE_MUX.in1
IS_HWXFER        -> FINAL_STORE_MUX.sel
FINAL_STORE_MUX.out -> DATA_RAM.data_in
```

Remove the old direct connection from `rd_b` to `DATA_RAM.data_in`; otherwise
the RAM input will have two drivers.

## MEM-G — decode halfword load versus store

In the extra-load/store encoding, `s_bit` carries instruction bit 20, the load
bit. Place:

- `HW_LOAD`, a two-input AND gate;
- `NOT_HW_LOAD`, a NOT gate;
- `HW_STORE`, a two-input AND gate;
- `LOAD_ANY`, a two-input OR gate.

Attach tunnel `IS_LDR_CTRL` to the existing ordinary-load decode signal that
previously controlled the load path.

Wire:

```text
IS_HWXFER -> HW_LOAD.in0
s_bit     -> HW_LOAD.in1
HW_LOAD.out -> HW_LOAD_EN

s_bit          -> NOT_HW_LOAD.in
IS_HWXFER      -> HW_STORE.in0
NOT_HW_LOAD.out -> HW_STORE.in1
HW_STORE.out    -> HW_STORE_EN

IS_LDR_CTRL -> LOAD_ANY.in0
HW_LOAD_EN  -> LOAD_ANY.in1
LOAD_ANY.out -> LOAD_ANY_EN
```

Now replace the old ordinary-load-only control at every load write-enable
consumer with `LOAD_ANY_EN`. In the verified circuit it feeds:

- the load-related input of the gate that produces `ldr_reg_we`;
- the load/read reporting path that produces `mem_read`.

Add `HW_STORE_EN` as the second input of the OR gate that drives
`DATA_RAM.write_enable`. Preserve the ordinary store-enable input on the other
side of that OR gate.

Do not connect `is_hwxfer` directly to RAM write enable. That would make
`LDRH`, `LDRSB`, and `LDRSH` write memory.

## MEM-H — split RAM output into bytes and halfwords

From `RAM_DATA`, create:

```text
RAM_B0 = RAM_DATA[7:0]
RAM_B1 = RAM_DATA[15:8]
RAM_B2 = RAM_DATA[23:16]
RAM_B3 = RAM_DATA[31:24]

RAM_LO16 = RAM_DATA[15:0]
RAM_HI16 = RAM_DATA[31:16]
```

Use one four-fan 32-to-four-bytes splitter and one two-fan 32-to-two-halfwords
splitter. Verify fan ordering by placing temporary probes on `RAM_B0` and
`RAM_B3`; do not assume the nearest graphical fan is bit zero.

## MEM-I — byte and halfword extraction

### Select the addressed byte

Place `BYTE_SELECT_MUX`, data width 8 and select width 2:

```text
RAM_B0  -> BYTE_SELECT_MUX.in0
RAM_B1  -> BYTE_SELECT_MUX.in1
RAM_B2  -> BYTE_SELECT_MUX.in2
RAM_B3  -> BYTE_SELECT_MUX.in3
ADDR_LO -> BYTE_SELECT_MUX.sel
BYTE_SELECT_MUX.out -> BYTE_RAW
```

Connect `BYTE_RAW` to two Bit Extenders:

```text
BYTE_ZERO_LOAD: input 8, output 32, zero extend
BYTE_SIGN_LOAD: input 8, output 32, sign extend
```

Name their outputs `BYTE_ZEXT` and `BYTE_SEXT`.

### Select the addressed halfword

Place `HALF_SELECT_MUX`, data width 16 and select width 1:

```text
RAM_LO16 -> HALF_SELECT_MUX.in0
RAM_HI16 -> HALF_SELECT_MUX.in1
ADDR1    -> HALF_SELECT_MUX.sel
HALF_SELECT_MUX.out -> HALF_RAW
```

Connect `HALF_RAW` to two Bit Extenders:

```text
HALF_ZERO_LOAD: input 16, output 32, zero extend
HALF_SIGN_LOAD: input 16, output 32, sign extend
```

Name their outputs `HALF_ZEXT` and `HALF_SEXT`.

## MEM-J — select the architectural load result

Place three multiplexers:

| Logical name | Attributes | Purpose |
|---|---|---|
| `HW_RESULT_MUX` | width 32, select width 2 | decode `SH` |
| `ORD_LOAD_MUX` | width 32, select width 1 | word versus unsigned byte |
| `FINAL_LOAD_MUX` | width 32, select width 1 | ordinary versus extra transfer |

Wire the extra-transfer result using `SH_TYPE` directly:

```text
32-bit zero constant -> HW_RESULT_MUX.in0  # SH=00, unused here
HALF_ZEXT            -> HW_RESULT_MUX.in1  # SH=01, LDRH
BYTE_SEXT            -> HW_RESULT_MUX.in2  # SH=10, LDRSB
HALF_SEXT            -> HW_RESULT_MUX.in3  # SH=11, LDRSH
SH_TYPE              -> HW_RESULT_MUX.sel
HW_RESULT_MUX.out    -> HW_RESULT
```

Wire the final selection:

```text
BASE_LOAD       -> ORD_LOAD_MUX.in0
BYTE_ZEXT       -> ORD_LOAD_MUX.in1
MEM_B           -> ORD_LOAD_MUX.sel
ORD_LOAD_MUX.out -> ORD_LOAD

ORD_LOAD        -> FINAL_LOAD_MUX.in0
HW_RESULT       -> FINAL_LOAD_MUX.in1
IS_HWXFER       -> FINAL_LOAD_MUX.sel
FINAL_LOAD_MUX.out -> stage_MEM output pin load_data
```

Remove the old direct connection from the prior load-selection result to
`load_data`. The pin must have exactly one driver: `FINAL_LOAD_MUX.out`.

## MEM-K — memory verification checkpoint

Save the circuit, then run:

```bash
python3 tests/check_stage.py armv4t_2.circ stage_MEM
python3 -u tests/memory_lane_regression.py armv4t_2.circ
```

The functional target is:

```text
Memory lane checks: 19/19 passed
```

The current debug reference reports an unrelated undriven select feeding one
old multiplexer in `stage_MEM`. Do not reproduce an undriven input intentionally.
If your hand-wired stage checker is fully clean while 19/19 passes, that is
better than copying the warning.

---

# Part II — multiply family

## Important existing-name correction

Your current `stage_ID` output named `is_long_mul` is **not** the long-multiply
family signal. It is the existing short `MLA` accumulate control. Preserve it
electrically, but label its tunnel in `main` as:

```text
MUL_MLA
```

The genuinely new long-family signal is named:

```text
mul_long
```

Do not connect `is_long_mul` and `mul_long` together.

## ID-A — reuse the existing multiply signature signals

Open `stage_ID`. The current short-multiply decoder already has:

- a comparator proving the relevant instruction class is zero;
- a comparator proving `instr[7:4] == 0x9`;
- the 4-bit `opcode` output corresponding to `instr[24:21]`.

Tap those existing comparator equality outputs with tunnels:

```text
CLASS_ZERO = equality output of the class-zero comparator
MUL_SIG9   = equality output of the instr[7:4] == 9 comparator
LONG_OPCODE = the same internal 4-bit bus that drives output pin opcode
```

Do not place a second instruction splitter merely to obtain the same opcode
bus. Reusing the named `opcode` source avoids fan-order mistakes.

## ID-B — decode the four long forms

Place:

- `LONG_OPCODE_SPLIT`, incoming width 4 and fan-out 4;
- `NOT_BIT24`, a NOT gate;
- `LONG_DECODE`, a four-input AND gate;
- output pins `mul_long`, `mul_signed`, and `mul_long_acc`, each width 1.

The splitter bit meanings are:

```text
LONG_OPCODE[0] = instruction bit 21 = accumulate
LONG_OPCODE[1] = instruction bit 22 = signed
LONG_OPCODE[2] = instruction bit 23 = must be 1 for long multiply
LONG_OPCODE[3] = instruction bit 24 = must be 0 for long multiply
```

Wire:

```text
LONG_OPCODE -> LONG_OPCODE_SPLIT.combined

LONG_OPCODE_SPLIT.bit3 -> NOT_BIT24.in

CLASS_ZERO               -> LONG_DECODE.in0
MUL_SIG9                  -> LONG_DECODE.in1
LONG_OPCODE_SPLIT.bit2    -> LONG_DECODE.in2
NOT_BIT24.out             -> LONG_DECODE.in3

LONG_DECODE.out           -> output pin mul_long
LONG_OPCODE_SPLIT.bit1    -> output pin mul_signed
LONG_OPCODE_SPLIT.bit0    -> output pin mul_long_acc
```

This implements:

```text
mul_long     = CLASS_ZERO & MUL_SIG9 & opcode[2] & ~opcode[3]
mul_signed   = opcode[1]
mul_long_acc = opcode[0]
```

`mul_signed` and `mul_long_acc` are don't-care signals for non-long
instructions; `mul_long` prevents them from changing architectural state.

## ID-C — preserve the existing register routing

Do not rebuild the register-file read muxes. The current `stage_ID` already
produces the multiply operands:

```text
rm_val / the multiply rd_b path -> Rm
rs_value                        -> Rs
mul_acc_value                   -> Rn for MLA, RdLo for long accumulate
rn output                       -> Rd/RdHi field instr[19:16]
```

The primary write address already becomes `instr[15:12]` for the long family,
which is `RdLo`. `rn` is carried to `main` for the secondary `RdHi` write.

## ID-D — stage_ID verification checkpoint

Run:

```bash
python3 tests/check_stage.py armv4t_2.circ stage_ID
```

The stage must report no multi-driver, width, or undriven-input errors before
adding the execute hardware.

---

# Part III — execute-stage multiply arithmetic

## EX-A — add the stage interface pins

Open `stage_EX`. Add these input pins using the exact names and widths:

| Pin | Width | Source later in `main` |
|---|---:|---|
| `is_mult` | 1 | `stage_ID.is_mult` |
| `is_mla` | 1 | `stage_ID.is_long_mul` |
| `mul_acc_value` | 32 | `stage_ID.mul_acc_value` |
| `mul_long` | 1 | `stage_ID.mul_long` |
| `mul_signed` | 1 | `stage_ID.mul_signed` |
| `mul_long_acc` | 1 | `stage_ID.mul_long_acc` |

Add these outputs:

| Pin | Width | Meaning |
|---|---:|---|
| `mul_hi` | 32 | high half written to `RdHi` |
| `mul_long_we` | 1 | condition-qualified high write enable |

Place new pins after the existing interface pins so you do not reorder old
ports unexpectedly. After changing a subcircuit interface, inspect the instance
in `main` and reconnect by visible pin label.

Attach local tunnels:

```text
is_mult       -> EX_IS_MULT
is_mla        -> EX_IS_MLA
mul_acc_value -> EX_MUL_ACC
mul_long      -> EX_MUL_LONG
mul_signed    -> EX_MUL_SIGNED
mul_long_acc  -> EX_MUL_LONG_ACC
rd_b          -> EX_RM
rs_value      -> EX_RS
rd_a          -> EX_RD_HI
condition_checker.chk_out -> EX_COND_PASS
```

## EX-B — place the built-in multiplier

Place one Arithmetic-library `Multiplier`:

```text
data width = 32
```

Wire:

```text
EX_RM -> MULTIPLIER.a
EX_RS -> MULTIPLIER.b
1-bit constant 0 -> MULTIPLIER.carry_in

MULTIPLIER.low_output  -> MUL_PRODUCT
MULTIPLIER.carry_output -> MUL_UHI
```

In Logisim's component, the ordinary output is the low 32 bits and the carry
output is the high 32 bits of the 64-bit unsigned product.

Do not instantiate `mul_32`; it is not the verified datapath.

## EX-C — implement short `MUL` and `MLA`

Place:

- `MLA_ADDER`, width 32;
- `SHORT_RESULT_MUX`, width 32 and select width 1;
- a 1-bit constant zero for `MLA_ADDER.carry_in`.

Wire:

```text
MUL_PRODUCT -> MLA_ADDER.a
EX_MUL_ACC  -> MLA_ADDER.b
0           -> MLA_ADDER.carry_in
MLA_ADDER.out -> MLA_SUM

MUL_PRODUCT -> SHORT_RESULT_MUX.in0
MLA_SUM     -> SHORT_RESULT_MUX.in1
EX_IS_MLA   -> SHORT_RESULT_MUX.sel
SHORT_RESULT_MUX.out -> SHORT_MUL_RESULT
```

`EX_IS_MLA=0` produces `MUL`; `EX_IS_MLA=1` produces `MLA`.

## EX-D — extract operand sign bits explicitly

Place two `BitSelector` components:

```text
RM_SIGN_SELECT: input width 32, output group width 1
RS_SIGN_SELECT: input width 32, output group width 1
```

Drive each selector input-index port with a width-5 constant value 31.

Wire:

```text
EX_RM -> RM_SIGN_SELECT.data
31    -> RM_SIGN_SELECT.selector
RM_SIGN_SELECT.out -> RM_SIGN

EX_RS -> RS_SIGN_SELECT.data
31    -> RS_SIGN_SELECT.selector
RS_SIGN_SELECT.out -> RS_SIGN
```

Use `BitSelector`, not a visually convenient splitter tap. The splitter version
was the source of an undefined-value bug in real Logisim.

## EX-E — derive the signed high product from the unsigned product

Place:

- `CORR_A_MUX`, width 32;
- `CORR_B_MUX`, width 32;
- two width-32 zero constants;
- `CORR_A_NOT`, width 32;
- `CORR_B_NOT`, width 32;
- `SIGNED_STEP_ADDER`, width 32;
- `SIGNED_FINAL_ADDER`, width 32;
- two 1-bit constants with value 1 for the adder carry inputs;
- `SIGNED_HIGH_MUX`, width 32.

Select the correction operands:

```text
32-bit zero -> CORR_A_MUX.in0
EX_RS       -> CORR_A_MUX.in1
RM_SIGN     -> CORR_A_MUX.sel
CORR_A_MUX.out -> SIGNED_CORR_A

32-bit zero -> CORR_B_MUX.in0
EX_RM       -> CORR_B_MUX.in1
RS_SIGN     -> CORR_B_MUX.sel
CORR_B_MUX.out -> SIGNED_CORR_B
```

Subtract both corrections using NOT-plus-one:

```text
SIGNED_CORR_A -> CORR_A_NOT.in
MUL_UHI        -> SIGNED_STEP_ADDER.a
CORR_A_NOT.out -> SIGNED_STEP_ADDER.b
1              -> SIGNED_STEP_ADDER.carry_in
SIGNED_STEP_ADDER.out -> SIGNED_HI_STEP

SIGNED_CORR_B  -> CORR_B_NOT.in
SIGNED_HI_STEP -> SIGNED_FINAL_ADDER.a
CORR_B_NOT.out -> SIGNED_FINAL_ADDER.b
1              -> SIGNED_FINAL_ADDER.carry_in
SIGNED_FINAL_ADDER.out -> MUL_SHI
```

Choose the correct high half:

```text
MUL_UHI       -> SIGNED_HIGH_MUX.in0
MUL_SHI       -> SIGNED_HIGH_MUX.in1
EX_MUL_SIGNED -> SIGNED_HIGH_MUX.sel
SIGNED_HIGH_MUX.out -> LONG_PRODUCT_HI
```

The implemented equation is:

```text
LONG_PRODUCT_HI = MUL_UHI
                - (Rm[31] ? Rs : 0)
                - (Rs[31] ? Rm : 0)
```

## EX-F — implement 64-bit accumulation

Place:

- `LONG_LOW_ADDER`, width 32;
- `LONG_HIGH_ADDER`, width 32;
- `LONG_LOW_MUX`, width 32;
- `LONG_HIGH_MUX`, width 32;
- a 1-bit zero constant for `LONG_LOW_ADDER.carry_in`.

Wire:

```text
MUL_PRODUCT -> LONG_LOW_ADDER.a
EX_MUL_ACC  -> LONG_LOW_ADDER.b
0           -> LONG_LOW_ADDER.carry_in
LONG_LOW_ADDER.out       -> LONG_ACC_LO
LONG_LOW_ADDER.carry_out -> LONG_ACC_CARRY

LONG_PRODUCT_HI -> LONG_HIGH_ADDER.a
EX_RD_HI        -> LONG_HIGH_ADDER.b
LONG_ACC_CARRY  -> LONG_HIGH_ADDER.carry_in
LONG_HIGH_ADDER.out -> LONG_ACC_HI

MUL_PRODUCT    -> LONG_LOW_MUX.in0
LONG_ACC_LO    -> LONG_LOW_MUX.in1
EX_MUL_LONG_ACC -> LONG_LOW_MUX.sel
LONG_LOW_MUX.out -> LONG_RESULT_LO

LONG_PRODUCT_HI -> LONG_HIGH_MUX.in0
LONG_ACC_HI      -> LONG_HIGH_MUX.in1
EX_MUL_LONG_ACC  -> LONG_HIGH_MUX.sel
LONG_HIGH_MUX.out -> LONG_RESULT_HI
```

The low adder's carry output must drive the high adder's carry input. Connecting
only the two sums makes many small tests pass while breaking real 64-bit
accumulation.

## EX-G — merge short, long, and ordinary ALU results

Place:

- `MUL_WIDTH_MUX`, width 32;
- `ANY_MUL_OR`, two-input OR gate;
- `FINAL_EX_RESULT_MUX`, width 32.

Attach `ALU_RESULT_OLD` to the existing `ALU.result` output before disconnecting
its direct route to output pin `alu_result`.

Wire:

```text
SHORT_MUL_RESULT -> MUL_WIDTH_MUX.in0
LONG_RESULT_LO   -> MUL_WIDTH_MUX.in1
EX_MUL_LONG      -> MUL_WIDTH_MUX.sel
MUL_WIDTH_MUX.out -> ANY_MUL_RESULT

EX_IS_MULT  -> ANY_MUL_OR.in0
EX_MUL_LONG -> ANY_MUL_OR.in1
ANY_MUL_OR.out -> ANY_MUL

ALU_RESULT_OLD -> FINAL_EX_RESULT_MUX.in0
ANY_MUL_RESULT -> FINAL_EX_RESULT_MUX.in1
ANY_MUL        -> FINAL_EX_RESULT_MUX.sel
FINAL_EX_RESULT_MUX.out -> output pin alu_result
```

Remove the old direct `ALU.result -> alu_result` wire. The output pin must have
one driver.

## EX-H — generate the second result and its write enable

Wire the high result directly:

```text
LONG_RESULT_HI -> output pin mul_hi
```

Place `LONG_WRITE_AND`, a two-input AND gate:

```text
EX_MUL_LONG -> LONG_WRITE_AND.in0
EX_COND_PASS -> LONG_WRITE_AND.in1
LONG_WRITE_AND.out -> output pin mul_long_we
```

This condition gate is mandatory. Without it, a failed conditional long
multiply still corrupts `RdHi` through the secondary write port.

## EX-I — implement multiply `N` and `Z`

### N flag

Place two more 32-bit `BitSelector` components, each selecting index 31:

```text
SHORT_MUL_RESULT -> SHORT_N_SELECT.data
31               -> SHORT_N_SELECT.selector
SHORT_N_SELECT.out -> SHORT_MUL_N

LONG_RESULT_HI -> LONG_N_SELECT.data
31             -> LONG_N_SELECT.selector
LONG_N_SELECT.out -> LONG_MUL_N
```

Place `MUL_N_MUX`, one-bit data and one-bit select:

```text
SHORT_MUL_N -> MUL_N_MUX.in0
LONG_MUL_N  -> MUL_N_MUX.in1
EX_MUL_LONG -> MUL_N_MUX.sel
MUL_N_MUX.out -> MUL_FLAG_N
```

### Z flag

Place three 32-bit equality comparators and one 32-bit zero constant:

```text
SHORT_MUL_RESULT == 0 -> SHORT_MUL_Z
LONG_RESULT_LO   == 0 -> LONG_LO_Z
LONG_RESULT_HI   == 0 -> LONG_HI_Z
```

Place `LONG_ZERO_AND`:

```text
LONG_LO_Z -> LONG_ZERO_AND.in0
LONG_HI_Z -> LONG_ZERO_AND.in1
LONG_ZERO_AND.out -> LONG_MUL_Z
```

Place `MUL_Z_MUX`:

```text
SHORT_MUL_Z -> MUL_Z_MUX.in0
LONG_MUL_Z  -> MUL_Z_MUX.in1
EX_MUL_LONG -> MUL_Z_MUX.sel
MUL_Z_MUX.out -> MUL_FLAG_Z
```

Long zero is a full 64-bit comparison. Do not use only `LONG_RESULT_LO`.

## EX-J — merge multiply flags with existing ALU flags

Name the existing normal flag sources:

```text
ALU_FLAG_N = existing normal N value
ALU_FLAG_Z = existing normal Z value
ALU_FLAG_C = existing normal C value after logical/arithmetic selection
ALU_FLAG_V = existing normal V value
```

From the current CPSR register/splitter, name the stored flag bits:

```text
CURRENT_FLAG_C = current CPSR C bit
CURRENT_FLAG_V = current CPSR V bit
```

Place four one-bit multiplexers:

```text
ALU_FLAG_N     -> FINAL_N_MUX.in0
MUL_FLAG_N     -> FINAL_N_MUX.in1
ANY_MUL        -> FINAL_N_MUX.sel
FINAL_N_MUX.out -> FINAL_FLAG_N

ALU_FLAG_Z     -> FINAL_Z_MUX.in0
MUL_FLAG_Z     -> FINAL_Z_MUX.in1
ANY_MUL        -> FINAL_Z_MUX.sel
FINAL_Z_MUX.out -> FINAL_FLAG_Z

ALU_FLAG_C     -> FINAL_C_MUX.in0
CURRENT_FLAG_C -> FINAL_C_MUX.in1
ANY_MUL        -> FINAL_C_MUX.sel
FINAL_C_MUX.out -> FINAL_FLAG_C

ALU_FLAG_V     -> FINAL_V_MUX.in0
CURRENT_FLAG_V -> FINAL_V_MUX.in1
ANY_MUL        -> FINAL_V_MUX.sel
FINAL_V_MUX.out -> FINAL_FLAG_V
```

Reconnect the existing CPSR input combiner so it receives the four
`FINAL_FLAG_*` nets instead of the old direct ALU flag nets. Preserve the
existing condition and `S`-bit write-enable logic.

This implementation updates multiply `N` and `Z` while preserving `C` and `V`.

## EX-K — execute-stage verification checkpoint

Run:

```bash
python3 tests/check_stage.py armv4t_2.circ stage_EX
logisim-evolution --no-splash \
  --test-vector stage_EX tests/multiply_long_ex_vector.txt \
  armv4t_2.circ
```

The direct-vector target is:

```text
Passed: 4, Failed: 0
```

---

# Part IV — connect the stages in `main`

## MAIN-A — connect short multiply controls

Open `main`. Use pairs of same-named tunnels rather than long wires:

```text
stage_ID.is_mult       -> tunnel MUL_IS
tunnel MUL_IS          -> stage_EX.is_mult

stage_ID.is_long_mul   -> tunnel MUL_MLA
tunnel MUL_MLA         -> stage_EX.is_mla

stage_ID.mul_acc_value -> tunnel MUL_ACC, width 32
tunnel MUL_ACC         -> stage_EX.mul_acc_value
```

Again, `is_long_mul` is the old misleading name for the short `MLA` control.

## MAIN-B — connect long multiply controls

```text
stage_ID.mul_long      -> tunnel MUL_LONG
tunnel MUL_LONG        -> stage_EX.mul_long

stage_ID.mul_signed    -> tunnel MUL_SIGNED
tunnel MUL_SIGNED      -> stage_EX.mul_signed

stage_ID.mul_long_acc  -> tunnel MUL_LONG_ACC
tunnel MUL_LONG_ACC    -> stage_EX.mul_long_acc
```

Widths:

```text
MUL_LONG      = 1
MUL_SIGNED    = 1
MUL_LONG_ACC  = 1
```

## MAIN-C — isolate the existing secondary write-port signals

The current secondary register-file write port is driven by `stage_MEM` for
block loads. Rename only the `main` tunnels on those stage outputs:

```text
stage_MEM.wd2 -> MEM_WD2, width 32
stage_MEM.wa2 -> MEM_WA2, width 4
stage_MEM.we2 -> MEM_WE2, width 1
```

Do not change the pin names inside `stage_MEM`. These `MEM_*` tunnel names exist
only to distinguish memory's candidate values from the final register-file
signals `WD2`, `WA2`, and `WE2`.

## MAIN-D — bring out the long high result

```text
stage_EX.mul_hi      -> MUL_HI, width 32
stage_EX.mul_long_we -> MUL_LONG_WE, width 1
```

Attach a 4-bit tunnel named `RN` to `stage_ID.rn`. For long multiply this field
is the encoded `RdHi` register number.

## MAIN-E — arbitrate the secondary write port

Place:

- `WD2_SOURCE_MUX`, width 32;
- `WA2_SOURCE_MUX`, width 4;
- `WE2_SOURCE_OR`, two-input OR gate.

Wire:

```text
MEM_WD2      -> WD2_SOURCE_MUX.in0
MUL_HI       -> WD2_SOURCE_MUX.in1
MUL_LONG_WE  -> WD2_SOURCE_MUX.sel
WD2_SOURCE_MUX.out -> WD2

MEM_WA2      -> WA2_SOURCE_MUX.in0
RN           -> WA2_SOURCE_MUX.in1
MUL_LONG_WE  -> WA2_SOURCE_MUX.sel
WA2_SOURCE_MUX.out -> WA2

MEM_WE2      -> WE2_SOURCE_OR.in0
MUL_LONG_WE  -> WE2_SOURCE_OR.in1
WE2_SOURCE_OR.out -> WE2
```

The final tunnels continue to drive the existing `stage_ID` register-file
write-port inputs:

```text
WD2 -> stage_ID.wd2
WA2 -> stage_ID.wa2
WE2 -> stage_ID.we2
```

Remove the previous direct `stage_MEM.wd2/wa2/we2` routes to `WD2/WA2/WE2`.
Leaving them in place creates multiple drivers and bypasses arbitration.

The design assumes a memory secondary write and a long-multiply high write do
not occur in the same architectural instruction. `MUL_LONG_WE` selects the
multiply values when a long multiply is committing.

## MAIN-F — main verification checkpoint

Run:

```bash
python3 tests/check_stage.py armv4t_2.circ main
python3 -u tests/debug_multiply_suite.py armv4t_2.circ
```

The multiply target is:

```text
[PASS] MUL MLA UMULL UMLAL SMULL SMLAL
[PASS] 64-bit accumulate carry and signed high halves
[PASS] MULS/SMULLS N/Z condition behavior
27/27 result words correct
```

---

# Part V — final acceptance sequence

Do not wait until the entire circuit is wired before testing. Use this order:

1. Finish `stage_MEM`; run its structural check and memory 19/19.
2. Finish long decode in `stage_ID`; run its structural check.
3. Finish `stage_EX`; run its structural check and the 4/4 direct vector.
4. Finish `main`; run its structural check and multiply 27/27.
5. Run the full real-Logisim architectural suite.

Commands:

```bash
python3 tests/check_stage.py armv4t_2.circ stage_ID
python3 tests/check_stage.py armv4t_2.circ stage_EX
python3 tests/check_stage.py armv4t_2.circ stage_MEM
python3 tests/check_stage.py armv4t_2.circ stage_WB
python3 tests/check_stage.py armv4t_2.circ main

python3 -u tests/memory_lane_regression.py armv4t_2.circ
python3 -u tests/debug_multiply_suite.py armv4t_2.circ
python3 -u tests/adversarial_regression.py armv4t_2.circ
```

The verified debug reference currently produces:

```text
memory lane checks       19/19
multiply result words    27/27
direct long vectors       4/4
full architectural suite 53/54
```

The one full-suite failure is `SWP`:

```text
got=00000000 expected=000000aa
```

Do not debug `SWP` while migrating this checkpoint. It is a separate missing
instruction, not an expected consequence of halfword or multiply wiring.

## Fast fault-isolation table

| Symptom | First named net to inspect |
|---|---|
| Every subword store corrupts neighbors | `FINAL_MASK_MUX`, then `BE0..BE3` |
| Byte lanes appear reversed | `RAM_B0..RAM_B3` and `ADDR_LO` |
| High halfword acts like low halfword | `ADDR1` and `HALF_SELECT_MUX` |
| `LDRSB`/`LDRSH` stay positive | `BYTE_SEXT`/`HALF_SEXT`, then `HW_RESULT_MUX` |
| `LDRH` writes no register | `HW_LOAD_EN`, then `LOAD_ANY_EN` |
| `STRH` never changes RAM | `HW_STORE_EN`, then RAM write-enable OR |
| `MUL` works but `MLA` does not | `MUL_MLA`, `EX_MUL_ACC`, `MLA_SUM` |
| Unsigned long works, signed long fails | `RM_SIGN`, `RS_SIGN`, `MUL_SHI` |
| `UMLAL` low is right, high is off by one | `LONG_ACC_CARRY` |
| Long low writes but high stays unchanged | `MUL_LONG_WE`, `MUL_HI`, secondary write muxes |
| False conditional long multiply changes `RdHi` | `LONG_WRITE_AND`/`MUL_LONG_WE` |
| `SMULLS` gets N wrong | `LONG_MUL_N` must come from `LONG_RESULT_HI[31]` |
| Long zero gets Z wrong | `LONG_LO_Z AND LONG_HI_Z` |
| Ordinary ALU flags break after multiply work | inputs zero of the four final flag muxes |
| Block loads break after main wiring | `MEM_WD2`, `MEM_WA2`, `MEM_WE2` arbitration inputs |

## Things deliberately not copied from the debug layout

The verified debug file accumulated a few investigative components. They are
not required for the behavior and should not be reproduced in the clean hand
layout:

- `BYTE_REP_OLD` and its four byte buffers/splitter combiner;
- `HALF_REP_OLD` and its two halfword buffers/splitter combiner;
- temporary probes whose only purpose was observing intermediate values;
- any dangling mux input or undriven select reported by the structural checker.

The tunnel names and equations in this document define the intended electrical
machine. Layout position is free; electrical equivalence and the regression
results are the acceptance criteria.

## Related documents

- `docs/HALFWORD_BYTE_ACCESS_IMPLEMENTATION.md` explains the ARM encoding,
  behavior, and why the memory regression is discriminating.
- `docs/MULTIPLY_FAMILY_IMPLEMENTATION.md` explains signed high correction,
  flags, long accumulation, and FPGA implications.
- `docs/HANDOFF_2026-09-02_MULTIPLY.md` records the exact measured debug hashes
  and stop point.
- `docs/ULTIMATE_CHECKLIST.md` records the larger ARM-state completion target.
