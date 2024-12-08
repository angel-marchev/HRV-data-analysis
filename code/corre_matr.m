A=bef_all1Decomposition;
B=aft_all1Decomposition;

% Compute row-wise correlation for matrices A and B
rowMeansA = mean(A, 2); % Mean of each row in A
rowMeansB = mean(B, 2); % Mean of each row in B

% Subtract means to center data
A_centered = A - rowMeansA;
B_centered = B - rowMeansB;

% Compute row-wise correlations
numerator = sum(A_centered .* B_centered, 2);
denominator = sqrt(sum(A_centered.^2, 2) .* sum(B_centered.^2, 2));
rowCorrelations = numerator ./ denominator;

% Display results
disp('Row-wise Correlations:');
disp(rowCorrelations);
