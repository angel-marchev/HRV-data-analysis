function plotHarmonics(harmonics, Fs, duration, m, signal)
    % PLOTHARMONICS Plots the first m harmonics as individual line plots and overlays the reconstructed signal with the real data.
    %
    % INPUTS:
    %   harmonics - Struct containing the results from decomposeHarmonicsWithEnergy.
    %               Must have fields: 'Frequency', 'Amplitude', and optionally 'Phase'.
    %   Fs - Sampling frequency (scalar).
    %   duration - Duration of the signal to be plotted (scalar, in seconds).
    %   m - Number of harmonics to plot (scalar, must be <= number of harmonics in input).
    %   signal - The original time-domain signal (vector).
    %
    % OUTPUTS:
    %   A line plot showing the first m harmonics, their combined signal, and the real data overlay.

    % Time vector for plotting
    t = 0:1/Fs:duration;

    % Check if m <= number of harmonics
    if m > length(harmonics.Frequency)
        error('m must be less than or equal to the number of harmonics.');
    end

    % Ensure signal matches the selected duration
    realData = signal(1:length(t));

    % Initialize combined signal
    combinedSignal = zeros(size(t));

    % Store individual harmonic signals
    individualSignals = zeros(m, length(t)); % For plotting harmonics separately

    % Reconstruct the combined signal using magnitude and phase
    for i = 1:m
        % Compute each harmonic signal
        freq = harmonics.Frequency(i);
        amplitude = harmonics.Amplitude(i);
        phase = angle(harmonics.Amplitude(i)); % Include phase information

        % Generate the harmonic
        individualSignals(i, :) = amplitude * cos(2 * pi * freq * t + phase);

        % Add this harmonic to the combined signal
        combinedSignal = combinedSignal + individualSignals(i, :);
    end

    % Plot the individual harmonics
    figure;
    subplot(2, 1, 1);
    hold on;
    for i = 1:m
        plot(t, individualSignals(i, :), 'DisplayName', sprintf('Harmonic %d: %.2f Hz', i, harmonics.Frequency(i)));
    end
    hold off;
    title(sprintf('First %d Individual Harmonics', m));
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('show');
    grid on;

    % Plot the combined signal with real data overlay
    subplot(2, 1, 2);
    plot(t, combinedSignal, 'k', 'LineWidth', 1.5, 'DisplayName', 'Combined Signal'); % Combined signal
    hold on;
    plot(t, realData, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Real Data'); % Real data overlay
    hold off;
    title(sprintf('Combined Signal vs Real Data (First %d Harmonics)', m));
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('show');
    grid on;
end

