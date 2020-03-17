function transitions = generate_bistable_binary_data(N_BITS, TPM, TLM, multiline, btw_subs_trans)
    % multiline removes transitions.
    merged = transpose(simulate(TPM, N_BITS));
    if multiline
        
        transition_cells = cell(fix(sqrt(N_BITS)), 1);
        curr_arr = [];
        curr_n = 1;
        pos = 1;
        for i = 2:length(merged)
            j = i-1;
            from = merged(1, j);
            to = merged(1, i);
            % check if this transition is between subsystems
            if ismember([from,to], btw_subs_trans, 'rows')
                % if it is, start a new row.
                transition_cells{pos, 1} = curr_arr;
                curr_arr = [];
                pos = pos + 1;
            else
                curr_arr = [curr_arr TLM(from, to)]; %slow
            end
        end
        transition_cells{pos, 1} = curr_arr;
        transition_cells = transition_cells(~cellfun('isempty',transition_cells));
        transitions = transition_cells;
    else
        transition_list = zeros(1, length(merged) - 1);
        for i = 2:length(merged)
            j = i-1;
            from = merged(1, j);
            to = merged(1, i);
            transition_list(1, j) = TLM(from, to);
        end
        transitions = {transition_list};
    end
    
end