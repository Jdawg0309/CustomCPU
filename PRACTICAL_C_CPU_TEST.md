# Practical Freestanding C CPU Test

This is the acceptance test for the first practical-C milestone. The ROM is
linked from startup assembly and compiler-generated ARMv4T C; no C instruction
is manually translated.

## Build

```text
make -C c_tests clean verify
make -C c_tests verify-logisim
```

The build produces:

```text
c_tests/practical_rom   Logisim instruction image
c_tests/practical.dump  Reviewed ARM disassembly
```

The target is ARM7TDMI in ARM state. Startup initializes `SP` to `0x400`, passes
the loop count in `R0`, calls `main`, and enters a branch-to-self loop after it
returns. The C function loads a stack-backed volatile seed, executes a
conditional loop, and stores its result through a volatile pointer to byte
address `0x100` (`RAM[40]`).

`verify-logisim` loads the ROM into a temporary copy of the real circuit, uses
the existing `is_BX` output as a test halt, runs Logisim headlessly, saves RAM,
and verifies `RAM[40]` and `RAM[FF]`. It does not modify `armv4t.circ`.

## Load

1. Open `armv4t.circ` in Logisim Evolution.
2. Load `cpu/decode_opcode.rom` into the 64K x 10-bit decoder ROM.
3. Load `c_tests/practical_rom` into `main.instr_rom`.
4. Reset the simulation.
5. Tick the clock 35 times.

`main.instr_rom` is now 256 x 32 bits and `pc_fetch.pc_out` carries `PC[9:2]`.

## Expected Progress

| After tick | `pc_fetch.pc_out` | Important state |
|---:|---:|---|
| 1 | `01` | `R13=00000400` |
| 2 | `02` | `R0=00000004`; C argument prepared |
| 3 | `04` | `R14=0000000C`; `BL main` completed |
| 6 | `07` | `R13=000003F8`; `RAM[FF]=00000001` |
| 10 | `0B` | `R0=00000000`; loop initialized |
| 15 | `0B` | `R0=00000002`; `R1=00000002`; `R3=00000002` |
| 20 | `0B` | `R0=00000006`; `R1=00000004`; `R3=00000003` |
| 25 | `0B` | `R0=0000000D`; `R1=00000007`; `R3=00000004` |
| 30 | `10` | `R0=00000018`; `R1=0000000B`; `CPSR.Z=1` |
| 32 | `12` | `RAM[40]=00000018`; C pointer store completed |
| 33 | `13` | `R13=00000400`; stack restored |
| 34 | `03` | `BX LR` returned to startup |
| 35+ | `03` | stable branch-to-self halt |

## Final Signature

```text
R0       = 00000018
R1       = 0000000B
R2       = 00000000
R3       = 00000000
R12      = 00000004
R13      = 00000400
R14      = 0000000C
CPSR.Z   = 1
RAM[40]  = 00000018
RAM[FF]  = 00000001
pc_out   = 03
```

This signature proves GCC compilation and linking, startup, stack allocation,
stack word loads/stores, a conditional C loop, `BL`, `BX LR`, return-value ABI,
RAM output, and stable termination on the CPU.
