# CustomCPU

A gate-level ARMv4T-subset CPU, designed and wired by hand in Logisim Evolution,
with the ROM images and sources that exercise it.

**Author:** Junaet Mahbub

```
armv4t.circ       the CPU (hand-wired master)
debug_armv4t.circ work-in-progress copy: adds PC-as-operand reads and working
                  literal pools (`ldr rD,=const`); default target of tests/
roms/             all ROM images, flat  — see roms/README.md for the catalog
src/              assembly and C sources for those ROMs
build/            ROM build and verification scripts
tests/            headless Logisim regression suites (push, pop, PC-write, ISA)
logisim/          Python backend for parsing/linting/rendering .circ files
fpga/fmax/        Verilog export + Vivado script for an Fmax measurement
backups/          timestamped circuit snapshots
```

Memory map: ROM occupies `0x0000-0x0FFF` (1024 words, addressed by `PC[11:2]`)
and RAM begins at `0x1000`.

## Building and verifying

```bash
make -C build verify        # rebuild the math ROMs and validate every image
python3 build/build.py      # regenerate ROMs from src/
```

## Running

Load `armv4t.circ` in Logisim Evolution, load a ROM image from `roms/` into the
instruction ROM, and run. `roms/README.md` lists each program and its expected
result.

## Full project record

Documentation, verification tooling, provenance records and the FPGA synthesis
flow are on the **`archive/full-2026-08-21`** branch:

```bash
git checkout archive/full-2026-08-21
```

That branch carries `PROJECT_LOG.md`, `PROJECT_STATUS.md`, `ROADMAP.md`,
`PROVENANCE.md`, `AI_CONTRIBUTIONS.md`, `tools/` and the timing flow. Nothing has
been removed from history — every file stays reachable in git.
