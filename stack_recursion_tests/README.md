# Stack / Recursion Staging Tests

Not part of the canonical `cpu/` release bundle yet. These are a working
scaffold for finishing the block-transfer (`PUSH`/`POP`) datapath so the core
can run a genuinely recursive function, per `PROJECT_STATUS.md`'s Immediate
Next Step:

> capture the register list, select each listed register, generate transfer
> addresses, connect RAM loads/stores, and write the final address back to SP.

Register-list capture and per-index selection are already verified (see
`PROJECT_LOG.md`). Transfer-address generation, the RAM load/store connection,
and SP writeback are not wired yet — so none of these three ROMs will produce
a correct final signature on the current hardware. They're staged here so
each can be loaded and re-checked as each piece above gets wired today.

Assembled with the same `arm-none-eabi-as` / `objcopy` pipeline as
`cpu/build.py`, into plain Logisim ROM images (`v3.0 hex words plain`).

## Load steps

Same as `cpu/README.md`: open `armv4t.circ`, load `cpu/decode_opcode.rom`
into the decoder, load one of these `.rom` files into the instruction ROM,
reset, and tick manually. `01` and `02` fit the current 16-word debug
instruction ROM as-is. `03_fib_recursive.rom` is 19 words — widen the
instruction ROM's `addrWidth` (or load into the 256-word practical-C ROM
slot) before running it.

## ROMs

| File | Words | Isolates | Expected signature once PUSH/POP is complete |
|---|---:|---|---|
| `01_push_pop_single.rom` | 7 | One register, one word of SP movement | R0=AA R1=400 |
| `02_push_pop_multi.rom` | 11 | Non-contiguous 3-register list `{r4,r5,lr}`, 3 words of SP movement, one nested call | R4=11 R5=22 R6=400 |
| `03_fib_recursive.rom` | 19 | Recursion depth > 1: every call frame's PUSH/POP must round-trip through RAM and restore SP exactly on every return path | R7=8 (fib(6)) |

`01` and `02` are non-recursive prologue/epilogue shapes — get these passing
first. `03` is the actual target: it only produces `R7=8` if stack frames
nest correctly, which is the acceptance bar for "recursive functions work."

## What's left (from `PROJECT_STATUS.md` / `ROADMAP.md`)

1. Generate the block-transfer effective address per active register index
   (base +/- 4 per P/U, already decoded by `helper_block_transfer_detect.rom`).
2. Connect that address and the selected register to RAM read (POP) and
   write (PUSH).
3. Write the final transfer address back to SP (R13) on completion, matching
   the existing single-register STR/LDR writeback pattern already verified
   in `helper_stack_store_writeback.rom` / `helper_stack_load_writeback.rom`.
4. Re-run `01`, `02`, `03` here in order; once `03` passes, replace
   asynchronous LDR with a synchronous wait state per the existing
   `Known Limits` note before calling this milestone complete.
