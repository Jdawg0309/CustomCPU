#!/usr/bin/env python3
"""Measure SP after the push AND after the pop, independently.

The earlier pop_steps.py assumed the post-push SP was 0x100-4n. When PUSH is
also broken, a symmetric push/pop error cancels and SP lands back on 0x100 --
so POP looked perfect while both halves were wrong. Never infer the base."""
import sys, os, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import push_suite as ps

ps.CIRC = sys.argv[1] if len(sys.argv) > 1 else "/home/junaet/Documents/CustomCPU/debug_armv4t.circ"
# Both must sit above ps.RAM_BASE now that ROM owns 0x0000-0x0FFF.
SP0, BASE = ps.RAM_BASE + 0x100, ps.RAM_BASE + 0x200

def prog(regs):
    rl = "{" + ",".join(f"r{r}" for r in regs) + "}"
    return "\n".join([".syntax unified", ".arm", ".global _start", "_start:",
        f"    mov sp, #{SP0}", f"    push {rl}", f"    mov r12, #{BASE}",
        "    str r13, [r12]", f"    pop {rl}",
        # POP currently writes every scanned register, so r12 may be destroyed.
        # Re-establish it after the transfer before using it as a store base.
        f"    mov r12, #{BASE}", "    str r13, [r12, #4]",
        "    bx lr"]) + "\n"

print(f"circuit: {ps.CIRC}")
print(f"{'list':<16}{'n':>2} {'SP after push':>14} {'expect':>8} {'SP after pop':>13} {'expect':>8}   verdict")
for regs in ([0], [0,1], [0,1,2], [0,1,2,3], [0,7], [5,6]):
    with tempfile.TemporaryDirectory() as wd:
        words = ps.assemble(prog(regs), wd)
        halted, osc, ram = ps.run_rom(words, wd)
    n = len(regs)
    sp_push = int(ram.get((BASE - ps.RAM_BASE)//4,   "00000000"), 16)
    sp_pop  = int(ram.get((BASE - ps.RAM_BASE)//4+1, "00000000"), 16)
    e_push, e_pop = SP0 - 4*n, SP0
    ok = (sp_push == e_push) and (sp_pop == e_pop)
    tag = "{" + ",".join("r%d"%r for r in regs) + "}"
    note = "ok" if ok else ("PUSH bad" if sp_push != e_push else "POP bad")
    if not halted or osc: note += " (halt/osc)"
    print(f"{tag:<16}{n:>2} {sp_push:>14x} {e_push:>8x} {sp_pop:>13x} {e_pop:>8x}   {note}")
