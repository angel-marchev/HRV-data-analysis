% Sample data
data = a;

% Compute descriptive statistics
meanValue = mean(data);
medianValue = median(data);
stdValue = std(data);
rangeValue = range(data);


% Display the results
fprintf('Descriptive Statistics:\n');
fprintf('Mean: %.2f\n', meanValue);
fprintf('Median: %.2f\n', medianValue);
fprintf('Standard Deviation: %.2f\n', stdValue);
fprintf('Range: %.2f\n', rangeValue);
