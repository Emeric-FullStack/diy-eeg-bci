# diy-eeg-bci

[![CI](https://github.com/Emeric-FullStack/diy-eeg-bci/actions/workflows/ci.yml/badge.svg)](https://github.com/Emeric-FullStack/diy-eeg-bci/actions/workflows/ci.yml)
![Python 3.12](https://img.shields.io/badge/python-3.12-blue)
[![Code: MIT](https://img.shields.io/badge/code-MIT-green)](LICENSE)
[![Hardware: CERN-OHL-P-2.0](https://img.shields.io/badge/hardware-CERN--OHL--P--2.0-green)](hardware/LICENSE)

> **FR** : Interface cerveau-machine « fait maison ». Objectif : ouvrir et fermer une pince, virtuelle puis réelle, par l'EEG, de façon fiable. On part de données EEG publiques, puis on passe à un capteur 2 canaux sur Arduino. Projet d'apprentissage documenté séance par séance dans [`docs/log/`](docs/log/).

A do-it-yourself brain-computer interface, built and documented step by step.

**Goal #1: open and close a gripper with EEG, reliably.** First a virtual gripper, then a real one. Everything else waits until that works.

The project starts from public EEG recordings, moves to a simulated real-time chain, then to a low-cost biosignal amplifier ([BioAmp EXG Pill](https://github.com/upsidedownlabs/BioAmp-EXG-Pill)) on an Arduino UNO R4 WiFi.

## First result: the alpha rhythm

When you close your eyes, the visual cortex at the back of the head starts oscillating at about 10 Hz. Finding this effect is the sanity check for the whole analysis pipeline.

![Power spectrum over O1, Oz and O2, eyes open vs eyes closed](docs/img/alpha-spectrum.png)

![Alpha power on the scalp, eyes open, eyes closed and difference](docs/img/alpha-topomap.png)

With eyes closed, power in the 8–12 Hz band over the occipital electrodes is about 16 times higher, with a peak at 10 Hz (subject 1 of the PhysioNet dataset). The difference map puts the effect at the back of the head, over the visual cortex.
Full analysis: [`analysis/01_eyes_open_vs_closed.ipynb`](analysis/01_eyes_open_vs_closed.ipynb).

## Architecture

Target design. Only the PhysioNet analysis exists today; the rest will be refined phase by phase.

```mermaid
flowchart LR
    subgraph sources [EEG source]
        physionet[PhysioNet recordings<br/>phase 1]
        bioamp[2 × BioAmp EXG Pill<br/>+ Arduino UNO R4 WiFi<br/>on battery, phase 3]
    end
    processing[Signal processing<br/>filters, band power, thresholds<br/>Python]
    app[Real-time app<br/>TypeScript]
    virtual[Virtual gripper<br/>MuJoCo SO-101, phase 2]
    real[Servo gripper<br/>separate power, phase 4]

    physionet --> processing
    bioamp -- Wi-Fi --> processing
    processing -- Lab Streaming Layer --> app
    app --> virtual
    app --> real
```

## Roadmap

Each phase ends with a milestone; the next one starts only when it is reached.

| Phase | Goal | Status |
|---|---|---|
| 0 | Environment and repository | Done |
| 1 | Read signals: sampling, filters, spectra, alpha and mu bands (PhysioNet) | In progress |
| 2 | Simulated chain: real-time processing, Lab Streaming Layer, virtual gripper in MuJoCo | Planned |
| 3 | First real signal: BioAmp EXG Pill + Arduino, artefacts, electrode contact, electrical safety | Planned |
| 4 | Brain commands: alpha switch, SSVEP, calibration, success rate | Planned |
| 5 | Mu-rhythm training: motor imagery, event-related desynchronisation | Planned |

## Repository layout

```
analysis/       Python notebooks exploring the PhysioNet recordings
docs/log/       Project log, one entry per work session
docs/img/       Figures used in this README
hardware/       Wiring diagrams and 3D files
scripts/        Project checks (run by CI)
data/           Local recordings, not versioned
```

Added with their phase: `app/` (phase 2, TypeScript real-time application) and `firmware/` (phase 3, Arduino code).

`hardware/case/` holds a draft enclosure for the electronics. It is on hold until the boards arrive and can be measured: see its [README](hardware/case/README.md).

## Reproduce

You need Python 3.12 and Git.

```bash
git clone https://github.com/Emeric-FullStack/diy-eeg-bci.git
cd diy-eeg-bci
python -m venv .venv                 # Windows: py -3.12 -m venv .venv
source .venv/Scripts/activate        # macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
```

Then open a notebook in `analysis/` with VS Code or `jupyter lab`. MNE downloads the PhysioNet files to `~/mne_data` on first run (about 2.5 MB per recording), so they never end up in the repository.

To check that every notebook still runs from top to bottom (CI runs the same script on each push):

```bash
bash scripts/check.sh
```

## Project log

Every work session gets an entry in [`docs/log/`](docs/log/): goal, result, what I learned and next step. It is the best place to follow the project, failures included.

## Safety

The measurement side (electrodes, amplifier, Arduino) always runs on battery and is never connected to mains or to a computer by cable: the signal travels over Wi-Fi. Motors have their own board and power supply. The setup only measures; it never sends current into the body.

This is a learning project, not a medical device.

## Data and references

EEG recordings: [EEG Motor Movement/Imagery Dataset](https://physionet.org/content/eegmmidb/1.0.0/) (PhysioNet, ODC-By 1.0), 109 subjects, 64 channels, 160 Hz.

- Schalk, G., McFarland, D. J., Hinterberger, T., Birbaumer, N., Wolpaw, J. R. (2004). BCI2000: a general-purpose brain-computer interface (BCI) system. *IEEE Transactions on Biomedical Engineering*, 51(6), 1034–1043.
- Goldberger, A. L., et al. (2000). PhysioBank, PhysioToolkit, and PhysioNet: components of a new research resource for complex physiologic signals. *Circulation*, 101(23), e215–e220.

Analysis built with [MNE-Python](https://mne.tools/).

## License

Code under the [MIT License](LICENSE). Hardware designs in `hardware/` under the [CERN Open Hardware Licence v2 – Permissive](hardware/LICENSE).
