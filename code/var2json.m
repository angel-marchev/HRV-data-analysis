data.before1_var = before1_var;
data.before2_var = before2_var;
data.bef_all = bef_all;
data.after1_var = after1_var;
data.after2_var = after2_var;
data.aft_all = aft_all;

% Convert struct to JSON
jsonStr = jsonencode(data);

% Save JSON to a file
fileID = fopen('data.json', 'w');
if fileID == -1
    error('Cannot open file for writing.');
end
fwrite(fileID, jsonStr, 'char');
fclose(fileID);
