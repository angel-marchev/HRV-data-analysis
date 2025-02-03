function [param_table, plot, z_test, t_test] = compare_analysis(data1, data2)
%% Desription
% makes comparative analysis of two datasets by their distribution fits

%% Fit distributions
[pd1,param_table1]=single_distfit(data1);
[pd2,param_table2]=single_distfit(data2);
param_table = vertcat(param_table1, param_table2);

%% Z test comparison
z_test = compare_distfit_z(param_table{1,1}, param_table{1,2}, size(data1,1),...
    param_table{2,1}, param_table{2,2}, size(data2,1));

t_test=compare_distfit_t(data1,data2);

%% Retrieve variable names for labeling
data1_name = inputname(1); % Name of data1 (e.g., 'before1_var')
data2_name = inputname(2); % Name of data2 (e.g., 'before2_var')

%% Graphical comparison
figureHandle = figure; % Save the figure handle to the workspace
plot_compare_distfit(data1,data2, pd1, pd2, data1_name, data2_name)
title('Compare Distribution Fits');
plot = getframe(figureHandle); % Save the figure object to the workspace
%imshow(savedFigure.cdata); % Display the figure content as an image
end