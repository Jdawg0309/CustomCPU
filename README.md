# CustomCPU

A gate-level ARMv4T-subset CPU built by hand in Logisim Evolution, with the ROM
images and assembly/C sources that exercise it.

- `armv4t.circ` — the CPU
- `cpu/` — canonical ROM images and their sources; see `cpu/README.md`
- `regression_roms/`, `math_roms/` — regression and math programs
- `c_tests/` — GCC-compiled freestanding C images
- `stack_recursion_tests/` — push/pop and recursion programs

## Full project record

Documentation, verification tooling, provenance and FPGA synthesis work live on
the **`archive/full-2026-08-21`** branch, which holds the complete history:

```bash
git checkout archive/full-2026-08-21
```

That branch contains `PROJECT_LOG.md`, `PROJECT_STATUS.md`, `ROADMAP.md`,
`PROVENANCE.md`, `AI_CONTRIBUTIONS.md`, `tools/` and the FPGA timing flow.
Nothing has been deleted from history — every file remains reachable in git.
