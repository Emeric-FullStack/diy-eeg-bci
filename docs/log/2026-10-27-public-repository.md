# 2026-10-27 — Public repository

## Goal

One copy of the project, published on GitHub, with a check that tells me when something breaks.

## Result

- The project lives in a single folder, `C:\Users\Emeric\diy-eeg-bci`, and on GitHub. The old folder, and the VS Code workspace that opened both folders at once, are retired: nothing in them is missing from the repository, and they get deleted once VS Code is closed (Windows locks them while it runs).
- Layout aligned with the plan: `analysis/` for the notebooks, `docs/log/`, `hardware/`; `app/` and `firmware/` will come with their phase.
- `scripts/check.sh` runs every notebook from top to bottom and fails on the first error. GitHub Actions runs it on each push.
- Licences: MIT for the code, CERN-OHL-P-2.0 for the hardware designs.
- `CLAUDE.md` gives the rules to any AI assistant working on the repository, starting with "there is only one copy of the project".

## What I learned

- Two copies of a project drift apart fast: each tool ends up writing to a different one. The fix is one folder, with Git as the reference.
- A CI check only helps if it fails for real: I tested `check.sh` on a deliberately broken notebook and it stopped with an error.
- Once a file is pushed to a public repository it should be treated as published for good, so personal notes stay out of it (`private/` is ignored by Git).

## Next

Phase 1 continues: filters (band-pass and 50 Hz notch) on the same recordings, then motor imagery runs.
