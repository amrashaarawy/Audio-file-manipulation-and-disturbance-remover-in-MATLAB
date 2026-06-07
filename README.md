# MATLAB Signal Processing Exercises

A set of MATLAB exercises covering audio signal filtering and sampling, completed as part of a signals coursework.

## Exercise 1 – Notch Filtering
Applied two notch filters (centered at 200 Hz and 10 kHz) to remove tonal disturbances from an audio signal. Symmetric spectral spikes were eliminated automatically via Fourier transform symmetry. The filtered audio was verified perceptually and spectrally.

## Exercise 2 – Downsampling & Anti-Aliasing
Downsampled the cleaned signal by a factor of 25 (Fs/25). Direct downsampling produced severe aliasing. 

To mitigate this, a low-pass anti-aliasing filter with cutoff at Fs/50 was applied before resampling — satisfying the Nyquist condition (Fs/25 > 2·fstop). The filtered-then-downsampled signal was significantly cleaner, though minor residual aliasing remained due to filter imperfections.

## Tools
- MATLAB (signal processing, FFT analysis, filter design)
