signal1=bef_all1Decomposition(14,:)';
signal2=aft_all1Decomposition(14,:)';

% Sampling frequency
Fs = 1; % Define Fs as 1 Hz
t = 0:1/Fs:length(signal1);           % Time vector (100 seconds, with 1-second intervals)

% Compute continuous wavelet transforms
[wt1, f] = cwt(signal1, 'amor', Fs);  % Morlet wavelet for signal 1
[wt2, ~] = cwt(signal2, 'amor', Fs);  % Morlet wavelet for signal 2

% Compute cross-wavelet transform
xwt = wt1 .* conj(wt2);  % Multiply wt1 by the conjugate of wt2

% Magnitude and phase
magnitude = abs(xwt);    % Joint power
phase = angle(xwt);      % Phase difference

% Plot cross-wavelet magnitude (power)
figure;
imagesc(t, f, magnitude);
shading interp;
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Cross-Wavelet Transform Magnitude');

% Plot phase
figure;
imagesc(t, f, phase);
shading interp;
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Cross-Wavelet Transform Phase');