function bestModel = fitBestArimaModel(data, maxP, maxD, maxQ, minP, minD, minQ)
    % Finds the best ARIMA model for the given data by searching through
    % a grid of p, d, q values and selecting the one with the lowest BIC.
    %
    % INPUTS:
    %   data  - The time series data to fit
    %   maxP  - Maximum AR order to consider
    %   maxD  - Maximum differencing order to consider
    %   maxQ  - Maximum MA order to consider
    %
    % OUTPUT:
    %   bestModel - The ARIMA model with the lowest BIC
    
    % Initialize variables to track the best model
    bestBIC = inf;
    bestModel = [];
    
    % Loop through all combinations of p, d, q
    for p = minP:maxP
        for d = minD:maxD
            for q = minQ:maxQ
                try
                    % Define ARIMA model structure
                    model = arima(p, d, q);
                    
                    % Fit the model
                    [fittedModel, ~, logL] = estimate(model, data, 'Display', 'off');
                    
                    % Extract other necessary components
                    n = length(data);
                    numParams = numel(fittedModel.Constant) + numel(fittedModel.AR) + numel(fittedModel.MA) + 1; % +1 for variance
                    
                    % Use the helper function to compute BIC
                    modelBIC = calculateBIC(logL, n, numParams);
                    
                    % Print current BIC and best BIC so far
                    fprintf('ARIMA(%d,%d,%d), Current BIC: %.4f, Best BIC: %.4f\n', p, d, q, modelBIC, bestBIC);
    
                    % Update the best model if this one is better
                    if modelBIC < bestBIC
                        bestBIC = modelBIC;
                        bestModel = fittedModel;
                    end
                catch ME
                    % Some combinations may fail (e.g., model is not
                    % identifiable), so just skip them
                    fprintf('Failed to fit ARIMA(%d,%d,%d): %s\n', p, d, q, ME.message);
                end
            end
        end
    end
    
    if isempty(bestModel)
        error('No suitable ARIMA model could be fit to the data.');
    end
end
