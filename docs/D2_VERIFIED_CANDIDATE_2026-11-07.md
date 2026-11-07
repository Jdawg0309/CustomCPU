# D2: tested candidate and manual wiring

The user-owned master is unchanged, SHA-256 `59bd2ea775fa52e50fd0379e528e4de5dac893f4b97556eba7848d9ebca108ba`.
Tested candidate: `build/d2_2026-11-07/candidate_v2.circ`.
Only `stage_MEM` changes: remove one word-path wire and add 13 components (mostly tunnels), including one 32-bit rotate-right Shifter and a shift-distance splitter. The existing RAM is retained.

## Direct Logisim evidence

- `regression_v2/results.json`: 53/53 pass, including all four LDR alignment cases, byte/halfword and register-offset accesses, NZCV preservation, and PC/stack returns.
- `patterns_d2/result.json`: 33/33 checks pass (32 data/address checks plus completion marker).
- Same pattern program on unchanged master: 16/33 checks pass.
- Patterns cover six RAM words at all four byte offsets, a ROM word at all four offsets, and unaligned pre-index/writeback and post-index loads.
- Both pattern runs halt with no reported oscillation. No VHDL run was performed for this D2-only change.
- `pattern_test.py` and each case's assembly, ROM/circuit, RAM dump and Logisim log are retained under the same build directory.

The initial `candidate.circ` and `regression/` are INVALID: my first copy-building script removed the wire but failed to insert the components because it misunderstood the text-span helper. They are retained for diagnostic provenance, not a CPU result. Use only `candidate_v2.circ` and `regression_v2/`.

## Manual steps in the existing master

1. Open `stage_MEM`. Find the probe **ram_rom_data**. Its vertical 32-bit wire has a short horizontal branch to the **upper data input of the mux immediately to its right**. That is the word-load path. Keep the vertical wire, its other branches, the lower mux input and the select connection intact.
2. Delete ONLY that short horizontal connection. Put a 32-bit tunnel named **D2_WORD** on its old source junction and a separate 32-bit tunnel named **D2_ROT** on the mux's now-disconnected upper input. Reference coordinates, if useful: removed wire (4140,2200) to (4180,2200).
3. In clear space, add an Arithmetic **Shifter**. Set **Data Bits = 32**, **Shift Type = Rotate Right** and label it **D2_ROTATE**. Connect a 32-bit **D2_WORD** tunnel to its data input and a 32-bit **D2_ROT** tunnel to its output. Its distance input is five bits; attach **D2_AMT**, width 5, there.
4. Obtain the existing two-bit byte address offset. Follow the address bus near the **ram_splitter** probe into its splitter; the two-bit branch runs down into a second splitter that separates the byte-address bits. Attach a width-2 tunnel **D2_A10** to that second splitter's combined input, without breaking its existing wiring. The exact combined-input location is (1950,2120). This must be effective address bits [1:0], not the RAM word-address bus.
5. Add a Wiring **Splitter**, **Bit Width In = 5**, **Fan Out = 2**. Assign bits **0,1,2 to branch 0** and bits **3,4 to branch 1**. Used backwards, it combines a 3-bit input and a 2-bit input into the five-bit shift distance.
6. Feed branch 0 with a **3-bit Constant 0**. Feed branch 1 with **D2_A10**, width 2. Connect the combined five-bit end to **D2_AMT**, width 5. Thus distance = `{address[1:0],000}` = 0,8,16,24.
7. Save the master, then rerun the retained tests against that saved file before declaring D2 complete. Candidate success does not verify later manual wiring.

No additional mux or load-enable gate is needed: insertion is specifically on the word-load input of the existing selection mux. Byte and halfword paths keep their existing input. The upper/lower input wording assumes the current saved layout, where the mux faces east.

Suggested staging: complete steps 1–3 and inspect the saved file before connecting the distance network. This is an incomplete intermediate state and should not be expected to execute correctly yet.
