# 2026-10-29 — Phase 1: alpha power over time, a one-bit brain switch

## Goal

Yesterday the ratio "eyes closed / eyes open" stayed abstract. Today: see the same thing as a curve over time, in `02_alpha_over_time.ipynb`.

## What I did

- First question of the day: what is "alpha"? Just the name of the 8–12 Hz band. Delta, theta, alpha, beta are labels for frequency ranges, like notes of a scale.
- Glued the eyes-open and eyes-closed minutes of subject 1 (O1, Oz, O2), cut the result into 2 s windows and computed the alpha power of each window.
- Caught a bug in the first version: it printed "eyes close at 122 s" instead of 61 s. `mne.concatenate_raws` extends its first argument in place, so the duration of `raws[0]` has to be read before concatenating. A function that modifies what you hand it is worth remembering.

## What I observed

- The curve is low and calm for 60 s, then jumps the moment the eyes close and stays high, with spikes. The two averages of notebook 01 (45 and 720) were hiding this curve.
- A threshold at 154 µV²/Hz, halfway between the two medians, classifies 98 % of the windows correctly. One line of code, three electrodes, no camera: a brain switch.
- The one error is a single window around 25 s that goes above the line while the eyes are open: a false positive, the main enemy of any BCI.
- `WINDOW` sets how many seconds go into each point. Longer windows smooth out the stray spikes but react later; shorter windows react fast and err more. Errors versus latency is the trade-off I will meet again all the way to the gripper.

## What I learned

- Alpha = 8–12 Hz, nothing more. Alpha power = how loud the signal is in that band.
- Band power per window, then a threshold: that is the whole of the simplest brain command.
- A false positive is worse than a miss for a command that moves something.

## Next

- Try `WINDOW = 1` and `WINDOW = 4`, then `CHANNELS = ["C3", "C4"]`: is the switch still usable where my headset will sit?
- Filters (band-pass, 50 Hz notch), then motor imagery runs 4, 8, 12 over C3/C4.
