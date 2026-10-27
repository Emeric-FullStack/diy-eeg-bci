# 2026-10-27 — Phase 0: environment setup

## Goal

Get a working Python environment and a clean project skeleton before touching any EEG data.

## Result

- Python 3.12.7 virtual environment in `.venv` with MNE 1.13.2, NumPy, SciPy, Matplotlib, Jupyter and ipykernel. Versions are pinned in `requirements.txt`.
- VS Code uses `.venv` by default; the Jupyter extension is installed.
- Project skeleton: `notebooks/`, `data/` (not versioned), `docs/log/`.
- Git repository initialised on `main` with a first local commit. Not pushed to GitHub yet.

## What I learned

- A virtual environment keeps the project's packages separate from the system Python. It stores absolute paths, so moving or renaming the project folder means recreating it.
- A program installed after an app was launched is not on that app's PATH: Git was installed but invisible to VS Code until a restart.
- Spaces and special characters (like the long dash `–`) in a project path tend to break tools later (Arduino IDE, scripts). The folder will be renamed `diy-eeg-bci`.
- Pinning versions in `requirements.txt` makes the environment reproducible on another machine.

## Next

Load the PhysioNet EEG Motor Imagery dataset with MNE and compare the spectrum with eyes open vs eyes closed.
