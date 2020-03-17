CH = 1;
LMAX = 4;
results = cell(13,1);
min_maxs = NaN(13,2);
for i = 1:13
    
    fname_general = eM_fly_maker(i, CH, LMAX);
    fname_dot = strcat(fname_general, '_inf.dot');
    [TPM, emissions] = get_TPM_and_emissions_from_dot(fname_dot);

    TPM(isnan(TPM)) = 0;

    [gs, ps] = get_strongly_connected_bipartitions(TPM);
    
    % find which split minimises the largest transition
    highest_outs = max(ps, [], 2);
    [min_max, ind] = min(highest_outs);
    results{i} = {gs, ps};
    min_maxs(i, :) = [min_max, ind];
    
end


%% a bit of prelim freq analysis

freq_results = frequency_analysis_per_epoch(1, 'eM_fly_7_ch_1L4_state_series');

freq_results = freq_results{1,1};

freq_results = cell2mat(freq_results);

freq_results = freq_results(:, 2:2:32);

first_split = sum(freq_results(:, 1:8), 2);
second_split = sum(freq_results(:, 9:16), 2);
freq_results = [first_split, second_split];