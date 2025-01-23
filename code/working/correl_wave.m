x=bef_all1Decomposition(7,:)';
y=aft_all1Decomposition(7,:)';

% Assuming your signals are stored in x and y
[acor, lag] = xcorr(x, y);

% Find the lag at which the cross-correlation is maximized (considering sign)
[maxCorr, I] = max(acor);
lagDiff = lag(I);

% Calculate the length difference
lenDiff = length(y) - length(x);

% Align signals based on lagDiff without padding with zeros
if lagDiff > 0
    % y lags behind x
    x_aligned = x(lagDiff+1:end);
    y_aligned = y(1:end-lagDiff);
elseif lagDiff < 0
    % x lags behind y
    x_aligned = x(1:end+lagDiff);
    y_aligned = y(-lagDiff+1:end);
else
    % No lag difference
    x_aligned = x;
    y_aligned = y;
end

% Calculate the Pearson correlation coefficient
R = corrcoef(x_aligned, y_aligned);
similarity = R(1, 2);
fprintf('Pearson Correlation Coefficient: %.4f\n', similarity);
