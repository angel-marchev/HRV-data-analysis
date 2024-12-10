function [harmonics, powerMetrics] = decomp_harm(signal, Fs, n)
% Decomposes a time-series signal into the first n most important harmonics
% based on power.
%
% Inputs:
%   signal   - Time-series data (vector)
%   Fs       - Sampling frequency (in Hz)
%   n        - Number of most important harmonics to extract
%
% Outputs:
%   harmonics    - Struct array with fields a, b, c, d for each harmonic
%   powerMetrics - Vector of power values for the extracted harmonics

    % Length of signal
    L = length(signal);
    T = 1 / Fs;  % Sampling period
    t = (0:L-1) * T;  % Time vector

    % 1. Compute Fourier Transform
    Y = fft(signal);
    P2 = abs(Y / L);  % Two-sided spectrum magnitude
    P1 = P2(1:floor(L/2)+1);  % Single-sided spectrum
    P1(2:end-1) = 2 * P1(2:end-1);  % Scale amplitude
    
    % Frequencies corresponding to FFT components
    freqs = Fs * (0:(L/2)) / L;

    % 2. Extract Power (P) and Sort by Importance
    amplitudes = P1;  % Amplitude of each frequency component
    powerMetrics = (amplitudes.^2) / 2;  % Power proportional to b^2 / 2
    [sortedPower, indices] = sort(powerMetrics, 'descend');

    % 3. Extract Top n Harmonics
    harmonics = struct('a', {}, 'b', {}, 'c', {}, 'd', {});
    a = mean(signal);  % DC component (offset)

    % Store first harmonic (constant offset)
    harmonics(1).a = a;
    harmonics(1).b = 0;
    harmonics(1).c = 0;
    harmonics(1).d = 0;

    % Process the most important n-1 oscillatory harmonics
    for i = 2:min(n, length(indices))
        idx = indices(i);  % Frequency index
        b = amplitudes(idx);  % Amplitude
        c = 2 * pi * freqs(idx);  % Angular frequency
        phase = angle(Y(idx));  % Phase of the frequency component

        harmonics(i).a = 0;  % No offset for oscillatory components
        harmonics(i).b = b;
        harmonics(i).c = c;
        harmonics(i).d = phase;
    end

    % Trim powerMetrics to match top n harmonics
    powerMetrics = sortedPower(1:n);
end
