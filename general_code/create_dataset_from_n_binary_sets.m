function [dataset, alphabet] = create_dataset_from_n_binary_sets(dsets)
    % creates a 2^nary set from n binary datasets.
    % first dimension in dsets is trials, 
    % second is binary_set n (channel)
    % third is timestamp.
    alphabet = 0:(size(dsets, 2))^2 - 1;
    dataset = dsets(:, 1, :);
    multiplier = 10;
    for i = 2:size(dsets, 2)
    dataset = dataset + multiplier * dsets(:, i, :);
    multiplier = multiplier * 10;
    end
    
end