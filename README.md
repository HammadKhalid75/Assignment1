# From Analog to Digital: Signal Simulation

In this post, I explore the process of converting an analog signal to a digital one using MATLAB simulation. The analog signal is a simple 100 Hz sine wave.

# Step 1: Analog Signal

We start with a continuous sine wave: x = sin(2πft). This represents real-world continuous signals like audio.

# Step 2: Sampling

Sampling discretizes the time axis. According to the Nyquist theorem, the sampling frequency (Fs) must be at least twice the signal frequency (200 Hz here) to avoid aliasing.

Below Nyquist (150 Hz): Aliasing distorts the signal, making it look like a lower frequency wave.
At Nyquist (200 Hz): Captures the signal minimally, but phase issues might arise.
Above Nyquist (1000 Hz): Accurate representation with no distortion. Plots show the sampled points; lower Fs leads to fewer points and potential misinformation.

# Step 3: Quantization

Quantization rounds amplitudes to discrete levels. We tested 8, 16, and 64 levels (3, 4, 6 bits). Lower levels (8) create a "staircase" effect, increasing error. Higher levels (64) make the signal closer to the original, reducing quantization noise. Overlaid plots highlight how more levels improve fidelity.

# Step 4: Encoding and Bitstream

Quantized values are converted to binary. Higher bits mean longer codes but better quality. The bitstream is the final digital representation.

# Conclusion

This simulation shows trade-offs: Higher Fs and bits improve quality but increase data size. Key takeaway: Digital signals approximate analogs; parameters like Fs and bits control accuracy vs. efficiency.
