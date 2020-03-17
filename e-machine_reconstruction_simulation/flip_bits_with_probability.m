function noised_sequence = flip_bits_with_probability(bin_sequence, p)
    % flips each bit in the sequence with probability p
    % bin_sequence should be 1 x n binary values
    p_flips = rand(1, size(bin_sequence, 2));
    p = 1-p;    % need to do this otherwise all bits are set to the same value.
    p_flips(p_flips > p) = true;
    p_flips(p_flips <= p) = false;
    
    noised_sequence = xor(bin_sequence, p_flips);
end