# CustomCPU

A gate-level ARMv4T-subset CPU, designed and wired by hand in Logisim Evolution,
with the ROM images and sources that exercise it.

**Author:** Junaet Mahbub

```
armv4t.circ    the CPU
roms/          all ROM images, flat  — see roms/README.md for the catalog
src/           assembly and C sources for those ROMs
build/         ROM build and verification scripts
```

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
