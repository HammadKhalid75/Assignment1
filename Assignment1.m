%% Analog to Digital Signal Conversion Simulation

% Original parameters
f = 100;                 % frequency = 100 Hz
t_analog = 0:0.0001:0.01; % very fine step for analog signal
x_analog = sin(2*pi*f*t_analog);

% Plot the original analog signal once
figure(1);
plot(t_analog, x_analog, 'LineWidth', 1.5);
title('Analog Signal (Sine Wave)');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;

% Nyquist frequency
Nyquist = 2 * f; % 200 Hz

% Different sampling frequencies to try
sampling_freqs = [150, 200, 1000]; % Below, at, above Nyquist

% Different quantization levels (8, 16, 64) corresponding to bits = 3,4,6
quant_levels = [8, 16, 64];
bits_list = log2(quant_levels); % [3,4,6]

% Loop over sampling frequencies
for i = 1:length(sampling_freqs)
    Fs = sampling_freqs(i);
    Ts = 1/Fs;
    n = 0:Ts:0.01; % Discrete sample points
    x_sampled = sin(2*pi*f*n);
    
    num_samples = length(x_sampled);
    
    % Plot sampled signal
    figure(1 + i*10); % Separate figure for each Fs
    stem(n, x_sampled, 'filled');
    title(['Sampled Signal at Fs = ' num2str(Fs) ' Hz']);
    xlabel('Time (s)'); ylabel('Amplitude');
    grid on;
    
    % Now loop over quantization levels for each Fs
    for j = 1:length(quant_levels)
        levels = quant_levels(j);
        bits = bits_list(j);
        
        x_min = min(x_sampled);
        x_max = max(x_sampled);
        q_step = (x_max - x_min)/levels; % Step size
        
        x_index = round((x_sampled - x_min)/q_step); % Map samples to indices
        x_quantized = x_index * q_step + x_min;      % Map back to amplitude
        
        % Plot quantized signal
        fig_num = 1 + i*10 + j; % Unique figure number
        figure(fig_num);
        stem(n, x_quantized, 'filled');
        hold on;
        plot(t_analog, x_analog, 'r--', 'LineWidth', 1); % Overlay analog for comparison
        hold off;
        title(['Quantized Signal at Fs=' num2str(Fs) ' Hz, Levels=' num2str(levels) ' (' num2str(bits) '-bit)']);
        xlabel('Time (s)'); ylabel('Amplitude');
        legend('Quantized', 'Original Analog');
        grid on;
        
        % Encoding (Binary Representation) - Display up to first 10 or available
        binary_codes = dec2bin(x_index, bits);
        
        disp_num = min(10, num_samples);
        disp(['--- First ' num2str(disp_num) ' encoded samples for Fs=' num2str(Fs) ' Hz, Levels=' num2str(levels) ' ---']);
        disp(binary_codes(1:disp_num,:));
        
        % Digital Bitstream - First up to 40 bits or available
        bitstream = reshape(binary_codes.', 1, []);
        bitstream_length = length(bitstream);
        disp_bits = min(40, bitstream_length);
        disp(['--- First ' num2str(disp_bits) ' bits of the stream for Fs=' num2str(Fs) ' Hz, Levels=' num2str(levels) ' ---']);
        disp(bitstream(1:disp_bits));
        
        % Compute quantization error for discussion
        quant_error = mean((x_sampled - x_quantized).^2); % MSE
        disp(['Mean Squared Error for Fs=' num2str(Fs) ' Hz, Levels=' num2str(levels) ': ' num2str(quant_error)]);
    end
end

%% Summary and Comparison
fprintf('\nSimulation complete!\n');
fprintf('Analog -> Sampling -> Quantization -> Binary Encoding -> Digital Stream\n');
fprintf('Tested Sampling Frequencies: %s Hz\n', num2str(sampling_freqs));
fprintf('Tested Quantization Levels: %s\n', num2str(quant_levels));

% Discussion points (to be expanded in blog):
% - Below Nyquist (150 Hz): Aliasing occurs, sampled signal appears as lower frequency wave. With only a few samples, the effect is pronounced in the inability to reconstruct the original wave.
% - At Nyquist (200 Hz): Barely captures the signal, but reconstruction might have issues at peaks.
% - Above Nyquist (1000 Hz): Faithful representation, no aliasing.
% - Quantization: Higher levels (e.g., 64) reduce stair-step effect and error, improving signal quality. Lower levels (e.g., 8) introduce more distortion.
% Run the script to generate plots, observe the differences in the overlaid plots.

% Note: For low sampling frequencies, there are fewer samples (e.g., 2 for 150 Hz, 3 for 200 Hz), which is why we display only available samples and bits.