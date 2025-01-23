function [output_var]=read_hrv(filename,sheetname)
%% Import data from spreadsheet
% Function for importing data from the typical spreadsheet output by the
% holter hardware used.
%
% filename is the .xlsx spreadsheet with data
% sheetname is the name of the sheet from the filename
% output_var is the name of the table to be used for these data
% 


%% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 13);

% Specify sheet and range
opts.Sheet = sheetname; %"Jan 2024"; % "April 7 2023", "April 26 2023", "Oct 2023"
opts.DataRange = "A:M";

% Specify column names and types
opts.VariableNames = ["Var1", "HR", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "HRConfidence", "HRV"];
opts.SelectedVariableNames = ["HR", "HRConfidence", "HRV"];
opts.VariableTypes = ["char", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double"];

% Specify file level properties
opts.ImportErrorRule = "omitrow";
opts.MissingRule = "omitrow";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["HR", "HRConfidence", "HRV"], "TreatAsMissing", '');

% Import the data
tabledata = readtable(filename, opts, "UseExcel", false);
output_notclean = tabledata(tabledata.HRV<101,:);

% Clear first low quality rows of data
output_var=cutoff_low_conf(output_notclean);

