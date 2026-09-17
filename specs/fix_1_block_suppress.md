# Fix 1 — stop block transfers corrupting a register

**Effort:** one pin, one comparator, one OR input, one tunnel.
**Fixes:** 11 of 14 LDM/STM forms, `pop_suite` `roundtrip_same`, 3 cases in
`tools/deep_matrix.py`.

## Mechanism

`block_transfer_control.active` is driven by `ACTIVE_REG.Q` — a **register**.
So `bt_active` is necessarily low on the transfer's first cycle (it cannot rise
until the next edge) and again on its last. On those two cycles every suppress
term in `stage_WB` is 0:

```
we = sbwe | bl_taken | (cond_pass & mem_read)
   | (alu_we & cond_pass & !(mem_read | data_ram_we | bl_taken
                             | branch_taken | bx_taken | bt_active))
```

so `alu_we & cond_pass` writes the ALU result — the base address — into
register `instr[15:12]`, which for a block transfer is the high nibble of the
register **list**. `pop {r4,pc}` therefore corrupts `r8`.

`push` and `stmdb` escape only by luck: they encode `instr[24:21]=9`, which the
ALU control ROM maps to `TEQ` with write-enable 0.

The signal `stage_WB` needs is a *combinational* one. `class_bits` is
`instr[27:25]`, available every cycle, and `0b100` is exactly LDM/STM.

## Steps

**1. Add the input pin to `stage_WB`.**
Name it `class_bits`, width **3**, direction input.
Place it **below `bt_active`**, which is currently the last pin in port order.
Ports bind by position, so anything placed above an existing pin silently moves
every wire after it onto the wrong port.

**2. Decode the class.**
Add a Comparator, width 3. Feed `class_bits` to one side and a Constant of
value `0x4`, width 3, to the other. The equality output is your new term —
call it `IS_BLOCK`.

*(A 3-input AND with two inverters works equally well: `class[2] & !class[1] &
!class[0]`. Use whichever reads better next to your existing gates.)*

**3. Widen the suppress OR.**
`stage_WB` has two OR gates. The one to change is the **6-input** one, whose
inputs are `mem_read, data_ram_we, bl_taken, branch_taken, bx_taken,
bt_active`. Change its `inputs` attribute from 6 to **7** and wire `IS_BLOCK`
to the new input.

Do **not** touch the 4-input OR (`sbwe, bl_taken, <AND>, <AND>`) — that is the
enable tree, and the legitimate LDM register writes come through its
`cond_pass & mem_read` term. They must stay live.

**4. Wire it in `main`.**
Drop a Tunnel labelled `CLASS` on `stage_WB`'s new `class_bits` pin. The net
already exists — it currently runs `stage_ID.class_bits → stage_EX, stage_MEM`.
No new net, just a third destination.

## Verify

```bash
python3 tests/check_stage.py  debug_armv4t_2.circ stage_WB   # expect: clean
python3 tests/check_stage.py  debug_armv4t_2.circ main       # expect: clean
python3 tools/deep_matrix.py  debug_armv4t_2.circ            # block 7/7
python3 tests/pop_suite.py    debug_armv4t_2.circ            # 7/7
```

The discriminator that matters, because it fails today and no older suite
catches it:

```
    ldr r12,=0x1100
    mov r1,#0x11
    mov r2,#0x22
    mov r0,#0x99
    stmia r12!,{r1,r2}       @ r0 must still be 0x99, not 0x1100
```

Then check the write path did not regress: `push_suite` must stay 10/10 and
`regression_py` must stay at 48/54.
