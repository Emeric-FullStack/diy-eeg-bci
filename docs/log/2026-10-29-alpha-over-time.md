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

## Turning the knobs (same day, second sitting)

- `WINDOW = 4`: 97 % and the stray spike near 25 s still touches the threshold. Longer windows did not remove it: the burst was strong enough to survive dilution. And 97 % is not worse than 98 %: with 30 windows instead of 61, a single error weighs 3 % instead of 2 %. A percentage only means something next to the number of windows behind it.
- `WINDOW = 1`: 98 %, and the errors moved: the first window at 0 s, the window sitting on the glue point at 61 s, and the last one at 121 s. Those are edges of the recording, not the brain. The 25 s burst no longer crosses. Window length does not make errors disappear, it changes *which* errors you make, and the shape of an error tells its cause.
- `CHANNELS = ["C3", "C4"]`, `WINDOW = 2`: 79 %. Medians 34 vs 96 µV²/Hz (×3) instead of 41 vs 576 (×14) over the occipital sites; the two halves of the curve overlap and the threshold has no margin. An eyes-closed switch with two central electrodes is not reliable.

Vocabulary I needed: an electrode position is a *site*, named after the 10-20 system; a chosen set of sites is a *montage*. Occipital = back of the head, central = middle, frontal = front. And no "blinks" anywhere in this: the subject keeps the eyes closed for a minute, and it is keeping them closed that raises alpha. A blink is a 100 ms artefact, not the signal.

## What I learned

- Alpha = 8–12 Hz, nothing more. Alpha power = how loud the signal is in that band.
- Band power per window, then a threshold: that is the whole of the simplest brain command.
- A false positive is worse than a miss for a command that moves something.
- Choosing where to put two electrodes is choosing which command you will be able to read: the alpha switch wants occipital sites; the gripper, through motor imagery, will want C3/C4 but another rhythm (mu) and another sign (a drop, not a rise).

## Next

- Filters (band-pass, 50 Hz notch), then motor imagery runs 4, 8, 12 over C3/C4.
