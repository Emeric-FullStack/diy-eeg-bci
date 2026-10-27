# diy-eeg-bci

> **FR** : Interface cerveau-machine « fait maison », de l'analyse d'EEG publics jusqu'à un casque Arduino qui pilote une application.
> Projet d'apprentissage documenté pas à pas : le journal de bord est dans `docs/log/`.

A do-it-yourself brain-computer interface: from analysing public EEG recordings to an Arduino-based headset driving an application.

## Roadmap

| Phase | Goal | Tools |
|-------|------|-------|
| 0 | Set up the environment | Git, Python 3.12, VS Code + Jupyter |
| 1 | Explore real EEG data (PhysioNet EEG Motor Imagery) | MNE, NumPy, SciPy, Matplotlib |
| 2 | Real-time streaming and simulation | pylsl, mujoco, Node.js LTS (TypeScript app) |
| 3 | Hardware: acquisition with the kit | Arduino IDE |

## Project layout

```
notebooks/   Phase 1: step-by-step signal exploration
data/        Local recordings and exports (not versioned)
docs/log/    Project log, one entry per work session
```

These folders will be added with their phase:

```
src/bci/     Reusable Python code, once it outgrows the notebooks
app/         Phase 2: TypeScript application
hardware/    Phase 3: Arduino sketches, wiring diagrams
```

## Setup

```powershell
py -3.12 -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

On macOS or Linux, use `python3.12 -m venv .venv` and `source .venv/bin/activate`.

MNE downloads the PhysioNet datasets to `~/mne_data` on first load, so they never end up in the repository.
