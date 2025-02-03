function bic = calculateBIC(logL, n, numParams)
    % Calculate Bayesian Information Criterion (BIC)
    % logL      - Log-likelihood from the fitted model
    % n         - Number of observations
    % numParams - Number of estimated parameters in the model
    bic = numParams * log(n) - 2 * logL;
end
