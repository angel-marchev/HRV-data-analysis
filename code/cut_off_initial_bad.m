function output = cut_off_initial_bad(tabledata)
%% cut off intital bad 
% cut-off initial bad recordings with HRV>101
% output and tabaledata are tables of 3 columns: HR, HRV, HRConfidence
% output is the table with all rows
% after the last row with HRV > 101

%% define boundary data sets
% Get the total number of rows
N = height(tabledata);

% Calculate the boundary indices for the first 25% and last 25%
firstQuarterEnd  = floor(0.25*N);
lastQuarterStart = ceil(0.75*N);

%% cutoff data
% 1) Find the last row (from row 1 up to firstQuarterEnd) that is > 100
firstPos = find(tabledata.HRV(1:firstQuarterEnd) > 100, 1, 'last')+1;

% 2) Find the last row (from lastQuarterStart to the end) that is < 101
lastPos = find(tabledata.HRV(lastQuarterStart:end) > 100, 1, 'first')-1;

% If we found both positions, convert lastPos to absolute index
if ~isempty(firstPos) % && ~isempty(lastPos)
    firstAbove = firstPos;  % since firstPos is already an absolute index in [1, firstQuarterEnd]
else
    firstAbove = 1;
end

if ~isempty(lastPos)
  % lastPos is relative to 'lastQuarterStart', so convert it to absolute
    lastAbove  = (lastQuarterStart - 1) + lastPos;
else
    lastAbove = N;
end

% Now trim the table to keep rows from firstAbove60 to lastAbove60
output = tabledata(firstAbove : lastAbove, :);


end
% %% Find the index of the last row whose HRV > 101
% lastHighIndex = find(tabledata.HRV > 101, 1, 'last');
% 
% %% Cutoff
% % If we found any row with HRV > 101, then keep only the rows after that index
% % Otherwise, keep the entire table.
% if ~isempty(lastHighIndex)
%     output = tabledata(lastHighIndex+1:end, :);
% else
%     output = tabledata;
% end

