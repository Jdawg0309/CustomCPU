# Project Log

## 2026-08-14

- Expanded instruction fetch from 16 to 256 words using `PC[9:2]`.
- Added the first complete freestanding build: ARM startup, linker script,
  GCC-compiled stack-backed loop, ROM generation, and exact-image checks.
- Built a 22-word practical-C acceptance image with an ABI argument, stack
  local, conditional loop, C pointer store, function return, and stable halt.
- Ran it headlessly on the real Logisim circuit to `BX LR`; verified
  RAM[40]=18 and RAM[FF]=1.
- Added canonical ARM-state PUSH/POP form detection for `STMDB SP!` and
  `LDMIA SP!`.
- Added `pc_fetch.hold` and integrated a multi-cycle block-transfer controller.
- Verified controller start, active, done, PC hold/release, PUSH countdown
  `F..0`, POP count-up `0..F`, and automatic terminal detection in `main`.
- Added and verified 16-bit block-transfer register-list capture and indexed
  selection; `0x4010` selects only R14 and R4 during either scan direction.
- Preserved the gate-level circuit as the reference implementation; the planned
  next-generation RTL will retain its adder, ALU, shifter, decode, control, and
  memory behavior before manual pipelining.

## 2026-08-13

- Completed load-side stack base writeback with simultaneous `Rd` and `Rn`
  writes through the rebuilt dual-write register file.
- Found the LDR timing failure: synchronous `RAM.out` changed only after the
  register-write edge, so a post-index load wrote stale data.
- Proved the diagnosis with a sacrificial-load ROM under synchronous-read RAM.
- Enabled asynchronous RAM reads for the current single-cycle datapath.
- Verified the final stack signature: R1=AA, R2=100, R13=100, RAM[3F]=AA.

## 2026-08-06

- Verified store-side stack base writeback.
- `STR R0,[SP,#-4]!` produced SP=FC and RAM[3F]=AA.
- `STR R0,[SP],#4` produced SP=104 and RAM[40]=55.
- Confirmed `STR R0,[SP,#4]` writes RAM without changing SP.

## 2026-08-05

- Added the 16-word Fibonacci RAM integration milestone ROM.
- Added a ROM that populates RAM[0..46] with every 32-bit signed Fibonacci value.
- Manually verified the complete F0..F46 RAM dump: all 47 words matched and
  RAM[0x2F] onward remained unchanged at zero.
- Added a 64-generation Rule 30 cellular-automaton ROM as a visual bitwise and
  RAM stress test.
- Created the flat `cpu/` release bundle with canonical ROM names.
- Added ten matching freestanding C reference implementations and host tests.
- Added reproducible math-ROM assembly and bundle validation.
- Split current status, roadmap, release procedure, and historical notes.

## 2026-08-04

- Verified STR writes to data RAM.
- Verified word LDR and STR with positive and negative immediate offsets.
- Passed the memory regression signature: R2=AA, R4=55, R5=33,
  RAM[07]=55, RAM[09]=AA.

## 2026-08-02

- Completed the memory-class decode and effective-address datapath.
- Added memory write suppression to the register-write control path.

## 2026-07-28

- Verified compiled leaf C addition and BX LR return behavior.
- Established the first compiler-produced machine-code regression.

## 2026-07-27

- Completed B, conditional B, BL, BX, and BX LR tests.
- Verified link-register and PC redirection behavior.

## 2026-07-26

- Completed CPSR N/Z/C/V storage and ARM condition checking.
- Gated architectural register writes with `condition_pass`.

## 2026-07-14

- Completed the initial ALU and carry-select adder work.
- Added the staged 32-bit barrel shifter and Operand2 immediate rotation path.

Detailed historical wiring notes were preserved in
`docs/ARCHITECTURE_NOTES_LEGACY.md`.
