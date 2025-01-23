function desc_table = descript(input_var)
    % Compute descriptive statistics
    meanValue = mean(input_var);
    medianValue = median(input_var);
    stdValue = std(input_var);
    rangeValue = range(input_var);
    
    % Get the name of the input variable
    var_name = inputname(1); % Retrieve the name of the first input argument
    
    % Create a table with the statistics
    desc_table = table(meanValue, medianValue, stdValue, rangeValue, ...
                              'VariableNames', {'Mean', 'Median', 'StdDev', 'Range'}, ...
                              'RowNames', {var_name});
end


% Display the results
% fprintf('Descriptive Statistics:\n');
% fprintf('Mean: %.2f\n', meanValue);
% fprintf('Median: %.2f\n', medianValue);
% fprintf('Standard Deviation: %.2f\n', stdValue);
% fprintf('Range: %.2f\n', rangeValue);
