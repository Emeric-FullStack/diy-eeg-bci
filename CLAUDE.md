# Working on this repository

Instructions for AI assistants (Claude Code, Claude Desktop) and contributors.

## One place

- This repository is the single source of truth: `C:\Users\Emeric\diy-eeg-bci` on Emeric's PC, `github.com/Emeric-FullStack/diy-eeg-bci` online. There is no other copy of the project. Never create or edit project files anywhere else.
- Open the folder itself in VS Code, not a `.code-workspace` file.
- The terminal is Git Bash: give Bash commands, not PowerShell.
- Python 3.12 virtual environment in `.venv`, packages pinned in `requirements.txt`.

## Scope

- Goal #1: open and close a gripper (virtual, then real) with EEG, reliably. Everything else waits.
- The hardware (2 × BioAmp EXG Pill, Arduino UNO R4 WiFi) is **not available yet**. Until it arrives, work only on public data (PhysioNet) and simulation. Never assume the hardware is there.
- An idea outside the current phase goes to the idea parking in Emeric's plan; don't develop it.
- Safety: the measurement side always runs on battery, never connected to mains or to the PC by cable. Never propose electrical stimulation.

## How to work

- Emeric is learning: explain each block of code, suggest one parameter to change to see its effect, and end with what to remember.
- Reply in French. Everything in the repository (code, comments, README, log, commit messages) is in English; the README keeps a French summary at the top.
- Each work session gets one log entry in `docs/log/YYYY-MM-DD-topic.md`: goal, result, what I learned, next.

## Before each commit

```bash
source .venv/Scripts/activate
bash scripts/check.sh
```

The script runs every notebook in `analysis/` from top to bottom. CI runs it again on GitHub at each push. Don't commit if it fails.

## Layout

| Folder | Content |
|---|---|
| `analysis/` | Python notebooks exploring the PhysioNet recordings |
| `docs/log/` | Project log, one file per session |
| `docs/img/` | Figures used in the README |
| `hardware/` | Wiring diagrams and 3D files (CERN-OHL-P-2.0) |
| `data/` | Local recordings, not versioned |
| `private/` | Personal notes, not versioned |
| `app/` | Phase 2: TypeScript real-time application (not started) |
| `firmware/` | Phase 3: Arduino code (not started) |
