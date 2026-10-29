# 2026-10-28 — Phase 1: running notebook 01 myself, and what a spectrum is

## Goal

Notebook 01 had been written and executed by the AI assistant without me, so its results were not mine yet. Goal of the session: run it on my machine, turn its knobs, and be able to explain the alpha result in three sentences without reading my notes.

## What I did

- Housekeeping first: the old project folder and the VS Code workspace that opened two folders at once were deleted. One folder, one repository. `AGENTS.md` (a copy of `CLAUDE.md`) was removed too: two identical files drift apart.
- Ran `01_eyes_open_vs_closed.ipynb` for the first time. The first cell downloaded the PhysioNet files to `~/mne_data`; the figures came out identical to the stored ones.
- Turned the knobs in the first cell, one at a time:
  - `SUBJECT = 2`: the effect is still there but weaker. Alpha varies a lot between people, which is why a BCI is calibrated on its user.
  - `OCCIPITAL = ["C3", "C4"]` (the two positions my future 2-channel headset will probably use): subject 2 gives 27.7 → 112.5 µV²/Hz, about ×4, against ×16 at the back of the head. Alpha spills over to the centre of the scalp but is born at the back.
  - Expected the sensor map to show my selection: it does not. `plot_sensors` draws everything in `raw`; only `picks` filters. Added `ch_groups=[picked]` so the selected electrodes stand out (`pointsize` only exists on `mne.viz.plot_sensors`, not on the `raw.plot_sensors` shortcut).
- At that point the spectrum and the ×16 were still blurry to me, and I said so. We stopped the real data and built `00_what_is_a_spectrum.ipynb` on a signal I generate myself, so the answer is known in advance.

## What I observed in notebook 00

- A sine at `FREQ = 10` shows 40 peaks in 4 seconds: 10 per second is what "10 Hz" means.
- Its spectrum is one spike at 10 Hz on a flat floor. The spike is the wave, the floor is the noise.
- `NOISE = 100`: the wave becomes unreadable in the time plot, yet the spike at 10 Hz is still sharp. The spectrum finds a wave the eye can no longer see.
- Two sines (10 and 25 Hz) mixed: two spikes, the smaller amplitude gives the smaller spike. Noise raises the floor but never moves a spike.
- The dB scale does not add noise, it makes the floor visible. A difference in dB reads as a ratio (+10 dB = ×10).
- Band power 8–12 Hz, "noise only" vs "noise + wave": ×64. Halving `AMPLITUDE` (50 → 25) brought it to ×17.7, close to subject 1's ×16, while the floor stayed at 4.2: power grows with the square of the amplitude.

## Where I got stuck

I read "Eyes closed / eyes open: ×17.7" as a count of eye blinks over some duration. It is not: the two conditions are two separate one-minute recordings, and the ratio compares the 10 Hz "volume" of one minute to the other. Even after the explanation it was not acquired, so we paused. Next session starts from a different angle: the same quantity drawn as a curve over time.

## Next

Draw alpha power second by second over the two minutes glued together, and see the switch happen.
