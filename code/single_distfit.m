function [pd,param_table]=single_distfit(data)
%% single_distfit function
% Fit normal distribution and extract parameters, where:
% pd - normal distribution fit
% mu - distribution mean
% sigma - distribution standard deviation
% par_stderr(1) - standard error of distribution mean
% par_stderr(2) - standard error of distribution standard deviation
% ci(:, 1) - lower and upper bound of 95% confidence interval for
% distribution mean
% ci(:, 2) - lower and upper bound of 95% confidence interval for 
% distribution standard deviation

%% Fit a normal distribution
pd = fitdist(data, 'Normal');

%% Extract fitted parameters
params = pd.ParameterValues;
mu = params(1); % Mean
sigma = params(2); % Standard deviation

%% Extract standard errors
paramCov = pd.ParameterCovariance;
par_stderr = sqrt(diag(paramCov));

%% Compute confidence intervals
ci = paramci(pd);

%% Create an output table

% Get the name of the input variable
var_name = inputname(1); % Retrieve the name of the first input argument
    
% Create a table with the statistics
param_table = table(mu, sigma, par_stderr(1), par_stderr(2), ci(1,1), ...
    ci(2,1), ci(1,2), ci(2,2), 'VariableNames', {'Mean', 'Std. Dev.', ...
    'Std. Err. Mean', 'Std. Err. Std. Dev', 'LB 95% Conf. Int. Mean', ...
    'UB 95% Conf. Int. Mean', 'LB 95% Conf. Int. Std. Dev.', ...
    'UB 95% Conf. Std. Dev.'}, 'RowNames', {var_name});


%% Display results
%disp(['Mean: ', num2str(mu)]);
%disp(['Standard Deviation: ', num2str(sigma)]);
%disp(['Standard Error of Mean: ', num2str(par_stderr(1))]);
%disp(['Standard Error of Standard Deviation: ', num2str(par_stderr(2))]);
%disp(['95% Confidence Interval for Mean: [', num2str(ci(1, 1)), ', ', num2str(ci(2, 1)), ']']);
%disp(['95% Confidence Interval for Standard Deviation: [', num2str(ci(1, 2)), ', ', num2str(ci(2, 2)), ']']);
end