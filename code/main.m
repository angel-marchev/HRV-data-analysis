

%% Data preparation
before1=read_hrv("..\processed_data\!ALL RAW DATA COMBINED.xlsx","Jan 2024");
before2=read_hrv("!ALL RAW DATA COMBINED.xlsx","April 7 2023");
after1=read_hrv("!ALL RAW DATA COMBINED.xlsx","April 26 2023");
after2=read_hrv("!ALL RAW DATA COMBINED.xlsx","Oct 2023");

a=length(before1);
b=length(before2);
c=length(after1);
d=length(after2);

minlen=min(a,b,c,d);

before1_var=before1.HRV(1:minlen,:);
before2_var=before2.HRV(1:minlen,:);
after1_var=after1.HRV(1:minlen,:);
after2_var=after2.HRV(1:minlen,:);

bef_all=[before1_var;before2_var];
aft_all=[after1_var;after2_var];

clearvars minlen a b c d before1 before2 after1 after2

%% Descriptives comparison

desc_table1 = descript(before1_var);
desc_table2 = descript(before2_var);
desc_table3 = descript(after1_var);
desc_table4 = descript(after1_var);

desc_table = vertcat(desc_table1, desc_table2, desc_table3, desc_table4);

