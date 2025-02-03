function cleaned_output_var=cutoff_low_conf(input_var, bias)

%% Cutoff the initial bad data of HRV records
% Take the table input_var and find the initial observations where  the hardware
% confidence is <bias and cut it off.
% bias is the minimum accepted level of HR confidence

%% define initial and final data set
% Get the total number of rows
N = height(input_var);

% Calculate the boundary indices for the first 25% and last 25%
firstQuarterEnd  = floor(0.25*N);
lastQuarterStart = ceil(0.75*N);

%% find the first good record and the lat good record
% 1) Find the last row (from row 1 up to firstQuarterEnd) that is < bias
firstPos = find(input_var.HRConfidence(1:firstQuarterEnd) < bias, 1, 'last')+1;

% 2) Find the first row (from lastQuarterStart to the end) that is < bias
lastPos = find(input_var.HRConfidence(lastQuarterStart:end) < bias, 1, 'first')-1;

% If we found both positions, convert lastPos to absolute index
if ~isempty(firstPos) %%&& ~isempty(lastPos)
    firstAbove60 = firstPos;  % since firstPos is already an absolute index in [1, firstQuarterEnd]
else
    firstAbove60 = 1;
end
    
if ~isempty(lastPos)
   % lastPos is relative to 'lastQuarterStart', so convert it to absolute
    lastAbove60  = (lastQuarterStart - 1) + lastPos;
else
    lastAbove60 = N;
end

    
% Now trim the table to keep rows from firstAbove60 to lastAbove60
cleaned_output_var = input_var(firstAbove60 : lastAbove60, :);

end



% 
% %% 
% if sum(input_var.HRConfidence<bias)>0
%     begin = find(input_var.HRConfidence<bias, 1, 'last' )+1;
%     cleaned_output_var = input_var(begin:end,:);
% else
%     cleaned_output_var = input_var;
% end