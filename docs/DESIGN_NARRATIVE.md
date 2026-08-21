# Design Narrative

> **This document must be written by the author, in the author's own words.**
>
> It is deliberately left as a skeleton. A design narrative is evidence of
> understanding, and understanding cannot be delegated — a narrative drafted by
> anyone other than the person who made the decisions is worth nothing as
> provenance, and worse than nothing if that fact later surfaces.
>
> The prompts below are the questions a reviewer would actually ask. Answer them
> in prose, in build order. Two or three sentences each is plenty. Where a
> decision turned out to be wrong, say so — the corrections are the most
> convincing part.

---

## 1. Why start with the adder?

*Prompt: what made arithmetic the first thing to build? What did having a
working 32-bit adder let you do next that you couldn't before?*

## 2. Why Kogge-Stone rather than ripple-carry?

*Prompt: what were you optimising for at the time? What did you understand about
the tradeoff then, and what did the FPGA measurement later teach you that
changed your mind? (Measured: `ks_32b` 86.64 MHz / 128 LUTs versus a built-in
adder at 151.71 MHz / 45 LUTs, because a hand-built prefix tree cannot reach the
dedicated carry chain.)*

## 3. Why a barrel shifter in five stages?

*Prompt: why staged powers of two rather than one large mux? Note that this
choice held up under measurement — the hand-built shifter matched the built-in
on speed at half the area, unlike the adder.*

## 4. Why did the register file need rebuilding for dual writes?

*Prompt: what forced the change from `reg16x32` to `reg16x32_1`? What
instruction could not be implemented without a second write port, and how did
you discover that?*

## 5. Why a separate block-transfer controller rather than extending the
existing datapath?

*Prompt: what is fundamentally different about `LDM`/`STM` compared with every
instruction before it? Why does holding the PC matter?*

## 6. The bugs worth recounting

*Prompt: pick two or three and describe how you found them, not just what they
were. Suggested, all documented in `PROJECT_LOG.md`:*

- *the combinational cycle in `mul_32`'s CSA reduction tree, localised to
  partial products `p2`–`p6`*
- *the block-transfer address advancing twice per register*
- *the `WD2` mux select needing `done` rather than `active`, because both are
  registered and `active` falls on the same tick `done` rises*
- *the test that inferred the post-push SP instead of measuring it, so a
  symmetric push/pop error cancelled and faked a pass*

## 7. What you would do differently

*Prompt: with what you know now, what would you build in a different order, or
not build at all?*

---

## Suggested figures

For each section, a screenshot of the relevant subcircuit at the commit where it
was introduced. Every historical revision is executable:

```bash
git show <commit>:armv4t.circ > /tmp/snapshot.circ   # then open in Logisim
```

`docs/full_timeline.md` gives the commit for each subcircuit's first appearance.
