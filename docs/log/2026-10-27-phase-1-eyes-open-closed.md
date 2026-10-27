# 2026-10-27 — Phase 1: eyes open vs eyes closed

## Goal

Load real EEG with MNE and find the alpha rhythm: the first effect any EEG pipeline should show.

## Result

Notebook: `analysis/01_eyes_open_vs_closed.ipynb`.

- Data: PhysioNet EEG Motor Movement/Imagery, subject 1, runs 1 (eyes open) and 2 (eyes closed). 64 channels, 160 Hz, 1 minute each. MNE downloads it to `~/mne_data`.
- Over the occipital electrodes (O1, Oz, O2), power in the 8–12 Hz band goes from 45 to 720 µV²/Hz when the eyes close, about 16 times more. The peak sits at 10 Hz.
- The waves are visible by eye in the raw signal, and the scalp map puts the effect at the back of the head, over the visual cortex.

## What I learned

- A power spectrum (Welch's method) shows how much of the signal sits at each frequency. Plotting it in dB makes small and large values readable on the same axis.
- The alpha rhythm is a good sanity check: it is large, easy to trigger and has a known location. If a pipeline can't find it, the problem is the pipeline.
- MNE needs electrode positions (`set_montage`) to draw scalp maps. The PhysioNet channel names need `eegbci.standardize` first.
- The `standard_1005` montage name is deprecated in MNE 1.13; the new name is `colin27_1005`.

## Next

Motor imagery: runs 4, 8 and 12 (imagine opening and closing the left or right fist). Look for the drop in 8–30 Hz power over C3 and C4 while the subject imagines the movement.
