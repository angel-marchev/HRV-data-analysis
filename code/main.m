%% Data preparation

rawfilename="..\processed_data\!ALL RAW DATA COMBINED.xlsx";
before1=read_hrv(rawfilename,"April 7 2023");
before2=read_hrv(rawfilename,"April 26 2023");
after1=read_hrv(rawfilename,"Oct 2023");
after2=read_hrv(rawfilename,"Jan 2024");
eq_size=1; %1 - cut to equal size the data

if eq_size==1
    a=size(before1,1);
    b=size(before2,1);
    c=size(after1,1);
    d=size(after2,1);

    minlen=min([a,b,c,d]);

    before1_var=before1.HRV(1:minlen,:);
    before2_var=before2.HRV(1:minlen,:);
    after1_var=after1.HRV(1:minlen,:);
    after2_var=after2.HRV(1:minlen,:);
else
    before1_var=before1.HRV;
    before2_var=before2.HRV;
    after1_var=after1.HRV;
    after2_var=after2.HRV;
end

bef_all=[before1_var;before2_var];
aft_all=[after1_var;after2_var];

clearvars minlen a b c d before1 before2 after1 after2 rawfilename eq_size

%% Descriptives comparison

desc_table1 = descript(before1_var);
desc_table2 = descript(before2_var);
desc_table3 = descript(after1_var);
desc_table4 = descript(after2_var);
desc_table5 = descript(bef_all);
desc_table6 = descript(aft_all);

desc_table = vertcat(desc_table1, desc_table2, desc_table3, desc_table4, desc_table5, desc_table6);

writetable(desc_table,"desc_table.csv",'WriteRowNames',true)

clearvars desc_table1 desc_table2 desc_table3 desc_table4

%% Distribution Analysis
[param_table, plot_all, z_test_all, t_test] = compare_analysis(bef_all, aft_all);
[param_table12, plot_12, z_test_12] = compare_analysis(before1_var, after2_var);
[param_table11, plot_11, z_test_11] = compare_analysis(before1_var, after1_var);
[param_table22, plot_22, z_test_22] = compare_analysis(before2_var, after2_var);
[param_table21, plot_21, z_test_21] = compare_analysis(before2_var, after1_var);
%[param_table_bef, plot_bef, z_test_bef] = compare_analysis(before1_var, before2_var);
%[param_table_aft, plot_aft, z_test_aft] = compare_analysis(after1_var, after2_var);
% Save the figure object to the workspace
%imshow(plot_all.cdata); % Display the figure content as an image
writetable(param_table,"param_table.csv",'WriteRowNames',true)

clearvars param_table_bef param_table_aft pd_bef pd_aft

%% fitted arima test
[autocorrelations, lags] = autocorr(before1_var);


figure;
autocorr(before1_var,'NumLags', 9000);
title('ACF of the time series');

figure;
parcorr(before2_var,'NumLags', 50);
title('PACF of the time series');

% Assuming you have four time series already loaded:
% before1_var, before2_var, after1_var, after2_var

% ARIMA orders (you might adjust these based on your data)
maxP = 2;  % AR order
maxD = 0;  % Differencing order
maxQ = 4;  % MA order
minP = 2;
minD = 0;
minQ = 4;
% Step 1: Fit ARIMA models
%bestModel = fitBestArimaModel(data, maxP, maxD, maxQ);

fprintf('Fitting ARIMA models...\n');
fittedBefore1 = fitBestArimaModel(before1_var, maxP, maxD, maxQ, minP, minD, minQ);
fittedBefore2 = fitBestArimaModel(before2_var, maxP, maxD, maxQ, minP, minD, minQ);
fittedAfter1 = fitBestArimaModel(after1_var, maxP, maxD, maxQ, minP, minD, minQ);
fittedAfter2 = fitBestArimaModel(after2_var, maxP, maxD, maxQ, minP, minD, minQ);

fitBefore1 = fitBestArimaModel(before1_var, maxP, maxD, maxQ, minP, minD, minQ);
fitBefore2 = fitBestArimaModel(before2_var, maxP, maxD, maxQ, minP, minD, minQ);

fitAfter1 = fitBestArimaModel(after1_var, maxP, maxD, maxQ, minP, minD, minQ);
fitAfter2 = fitBestArimaModel(after2_var, maxP, maxD, maxQ, minP, minD, minQ);

% Step 2: Extract ARIMA parameters
% (Assuming we compare AR coefficients for simplicity)
paramsBefore1 = cell2mat([fitBefore1.AR fitBefore1.MA]);
paramsBefore2 = cell2mat([fitBefore2.AR fitBefore2.MA]);
paramsAfter1 = cell2mat([fitAfter1.AR fitAfter1.MA]);
paramsAfter2 = cell2mat([fitAfter2.AR fitAfter2.MA]);

% Step 3: Compare parameters between pairs
fprintf('Comparing fitted ARIMA models...\n');
pairs = {'Before1-Before2', 'After1-After2', ...
         'Before1-After1', 'Before1-After2', ...
         'Before2-After1', 'Before2-After2'};
paramPairs = {paramsBefore1, paramsBefore2; 
              paramsAfter1, paramsAfter2; 
              paramsBefore1, paramsAfter1; 
              paramsBefore1, paramsAfter2; 
              paramsBefore2, paramsAfter1; 
              paramsBefore2, paramsAfter2};

for i = 1:numel(pairs)
    [h, p] = ttest(paramPairs{i,1}{1}, paramPairs{i,2}{1});
    fprintf('%s: p = %.4f, h = %d\n', pairs{i}, p, h);
end

[h, p] = ttest(paramsBefore2, paramsAfter1);

zzz=[paramsBefore1;paramsBefore2;paramsAfter1;paramsAfter2]

%% Compare decompossed signals
[harmonics, importanceMetrics, reconstructedSignal] = decomp_harm_ver2(bef_all, 2, 20, 20);
