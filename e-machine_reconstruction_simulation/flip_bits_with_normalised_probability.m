function noised_sequence = flip_bits_with_normalised_probability(bin_sequence, p)
    % flips each bit in the sequence with probability p
    % bin_sequence should be 1 x n binary values
    p_flips = randn(1, size(bin_sequence, 2));
    debug_copy = p_flips;
    upper = 0.5 + p/2;
    lower = 0.5 - p/2;
    p_flips(p_flips > upper | p_flips < lower) = false;
    p_flips(p_flips ~= false) = true;
    
    noised_sequence = xor(bin_sequence, p_flips);
end