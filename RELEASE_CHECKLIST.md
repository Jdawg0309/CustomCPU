# Release Checklist

## Required Checks

```text
make -C cpu clean verify
python3 build_regression_roms.py
git status --short
```

Then manually run the twelve regression ROMs listed in `cpu/README.md` against
the release candidate `armv4t.circ` and record any changed signatures.

## Release Contents

- `armv4t.circ`
- `cpu/` flat ROM and source bundle
- `README.md`
- `PROJECT_STATUS.md`
- `PROJECT_LOG.md`
- `ROADMAP.md`
- `RELEASE_CHECKLIST.md`

## Version Procedure

1. Confirm every generated ROM is current with `make -C cpu verify`.
2. Confirm the circuit passes all documented manual signatures.
3. Update `PROJECT_STATUS.md` and append the tested milestone to
   `PROJECT_LOG.md`.
4. Generate `cpu/MANIFEST.sha256` with `make -C cpu manifest`.
5. Commit the exact release contents and tag the commit.

Do not claim complete ARMv4T or ARM7TDMI compatibility until Thumb, exceptions,
privileged behavior, and the remaining memory forms have dedicated tests.
