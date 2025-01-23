function z_test = compare_distfit(mu1, sigma1, n1, mu2, sigma2, n2)

%% Despription
% Compare two normal distribution using z-test (assuming many observations)
% mu1 - mean of distribution 1
% mu2 - mean of distribution 2
% sigma1 - std of distribution 1 (population or large n)
% sigma2 - std of distribution 2
% n1 - sample size for distribution 1
% n2 - sample size for distribution 2

%% set params
alpha = 0.05;   % significance level

%% Compute the test statistic for a two-sided z-test
z_stat = (mu1 - mu2) / sqrt( (sigma1^2 / n1) + (sigma2^2 / n2) );

%% Two-sided p-value
p_value = 2 * (1 - normcdf(abs(z_stat)));

%% Decision
if p_value < alpha
    z_test = ['Reject the null hypothesis: the means differ (p = ', num2str(p_value, '%.3e'), ').'];
else
    z_test = ['Fail to reject the null: no significant difference (p = ', num2str(p_value, '%.3e'), ').'];
end

%disp(z_test)
