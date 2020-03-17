function [TLM] = get_TLM_for_em_of(memlength)
    
    % this is a convoluted and slow solution, but it highlights the workings of
    % epsilon machines. 
    cs_n = 2^memlength;
    TLM = zeros(cs_n,cs_n);
    
    for i = 0:cs_n-1
        % for each bit we need to get the two possible transitions it can
        % go to. We do two steps: shift left always happens, and then we
        % either add 0 or 1.
        left_shift = bitsll(uint64(i),1);
        % turn to binary
        bin_array = de2bi(left_shift);
        
        % grab only the memlength rightmost bits
        if length(bin_array) > memlength
            bin_array = bin_array(:, 1:memlength);
        end
        correct_l_shift = bi2de(bin_array);
        
        TLM(i+1, correct_l_shift + 1) = 1;
        
        % now set the least valued bit to 1
        one_added = bin_array;
        one_added(1, 1) = 1;
        dec_one_added = bi2de(one_added);
        
        TLM(i+1, dec_one_added + 1) = 1;
    end

end