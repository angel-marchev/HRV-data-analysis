%% Data preparation

rawfilename="..\processed_data\!ALL RAW DATA COMBINED.xlsx";
before1=read_hrv(rawfilename,"Jan 2024");
before2=read_hrv(rawfilename,"April 7 2023");
after1=read_hrv(rawfilename,"April 26 2023");
after2=read_hrv(rawfilename,"Oct 2023");
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

clearvars desc_table1 desc_table2 desc_table3 desc_table4

%% Distribution Analysis
[param_table, plot_all, z_test_all] = compare_analysis(bef_all, aft_all);
[param_table12, plot_12, z_test_12] = compare_analysis(before1_var, after2_var);
[param_table11, plot_11, z_test_11] = compare_analysis(before1_var, after1_var);
%[param_table22, plot_22, z_test_22] = compare_analysis(before2_var, after2_var);
%[param_table21, plot_21, z_test_21] = compare_analysis(before2_var, after1_var);
%[param_table_bef, plot_bef, z_test_bef] = compare_analysis(before1_var, before2_var);
%[param_table_aft, plot_aft, z_test_aft] = compare_analysis(after1_var, after2_var);
% Save the figure object to the workspace
%imshow(plot_all.cdata); % Display the figure content as an image

clearvars param_table_bef param_table_aft pd_bef pd_aft

%% Compare decompossed signals
[harmonics, importanceMetrics, reconstructedSignal] = decomp_harm_ver2(bef_all, 2, 20, 20);
