function [t_test,p_val]=compare_distfit_t(data1,data2)

[t_test, p_val] = ttest2(data1, data2, 'Alpha', 0.05, 'Vartype', 'unequal');

if t_test == 1
    t_test = ['Significant difference (p = ', num2str(p_val, '%.4f'), ').'];
    
else
    t_test = ['No significant difference (p = ', num2str(p_val, '%.4f'), ').'];
end
