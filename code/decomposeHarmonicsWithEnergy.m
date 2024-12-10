function [harmonics, importanceMetrics, reconstructedSignal] = decomposeHarmonicsWithEnergy(signal, Fs, n, m)
    % DECOMPOSEHARMONICSWITHENERGY Decomposes a signal into its most important harmonics.
    % Includes phase information for reconstruction and measures the level
    % of explanation using power contribution.
    %
    % INPUTS:
    %   signal - The time series signal (vector).
    %   Fs - Sampling frequency of the signal (scalar).
    %   n - Number of most important harmonics to extract (scalar).
    %   m - Number of harmonics to use for reconstruction (scalar).
    %
    % OUTPUTS:
    %   harmonics - A struct containing frequency, amplitude, phase, and power contribution of the top n harmonics.
    %   importanceMetrics - A vector containing the power contribution (percentage) of the top n harmonics.
    %   reconstructedSignal - Signal reconstructed using the top m harmonics.

    % Perform FFT
    L = length(signal);
    Y = fft(signal);  % Compute FFT
    P2 = abs(Y / L);  % Two-sided amplitude spectrum
    P1 = P2(1:L/2+1); % Single-sided amplitude spectrum
    P1(2:end-1) = 2 * P1(2:end-1); % Adjust for single-sided
    
    % Phase spectrum (single-sided)
    phase = angle(Y); % Two-sided phase spectrum
    singlePhase = phase(1:L/2+1); % Single-sided phase spectrum

    % Frequency vector
    f = Fs * (0:(L/2)) / L;

    % Calculate total signal energy
    totalEnergy = sum(P1.^2);

    % Calculate power contribution (energy) of each harmonic
    powerContribution = (P1.^2) / totalEnergy * 100; % Percentage of total energy

    % Find the most important harmonics
    [sortedPower, sortedIndices] = sort(powerContribution, 'descend');
    importantFrequencies = f(sortedIndices(1:n));
    importantAmplitudes = P1(sortedIndices(1:n));
    importantPhases = singlePhase(sortedIndices(1:n));
    importantPower = sortedPower(1:n);

    % Store results in a struct
    harmonics = struct('Frequency', importantFrequencies, ...
                       'Amplitude', importantAmplitudes, ...
                       'Phase', importantPhases, ...
                       'PowerContribution', importantPower);
    importanceMetrics = importantPower;

    % Display the results
    fprintf('Top %d Harmonics (by Power Contribution):\n', n);
    for i = 1:n
        fprintf('Harmonic %d: Frequency = %.2f Hz, Amplitude = %.4f, Phase = %.4f rad, Power Contribution = %.2f%%\n', ...
            i, importantFrequencies(i), importantAmplitudes(i), importantPhases(i), importantPower(i));
    end

    % Reconstruct the signal using the top m harmonics
    t = (0:L-1) / Fs; % Time vector
    reconstructedSignal = zeros(size(signal)); % Initialize reconstructed signal
    for i = 1:m
        % Add each harmonic
        reconstructedSignal = reconstructedSignal + ...
            importantAmplitudes(i) * cos(2 * pi * importantFrequencies(i) * t + importantPhases(i));
    end

    % Optional: Plot the spectrum with power contribution
    figure;
    stem(f, P1.^2 / totalEnergy * 100, 'b', 'LineWidth', 1.5); % Energy percentage spectrum
    hold on;
    scatter(importantFrequencies, importantPower, 'r', 'filled');
    hold off;
    title('Frequency Spectrum and Power Contribution of Top Harmonics');
    xlabel('Frequency (Hz)');
    ylabel('Power Contribution (%)');
    legend('Power Spectrum (%)', 'Top Harmonics');
    grid on;

    % Optional: Plot original vs reconstructed signal
    figure;
    plot(t, signal, 'b', 'LineWidth', 1.5);
    hold on;
    plot(t, reconstructedSignal, 'r--', 'LineWidth', 1.5);
    hold off;
    title('Original Signal vs. Reconstructed Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('Original Signal', sprintf('Reconstructed Signal (%d Harmonics)', m));
    grid on;
end
