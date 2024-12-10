function [cleaned_output_var]=cutoff_low_conf(input_var)

%% Cutoff the initial bad data of HRV records
% Take the table input_var and find the initial observations where  the hardware
% confidence is <20 and cut it off.
%

%% 
if sum(input_var.HRConfidence<20)>0
    begin = max(find(input_var.HRConfidence<20))+1;
    cleaned_output_var = input_var(begin:end,:);
end