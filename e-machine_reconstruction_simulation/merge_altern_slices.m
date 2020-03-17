function dataset = merge_altern_slices(dset1, dset2, L, multiline)
% Produces a txt file of a time series with alternating slices 
% of length l from dset1 and dset2
%      e.g. given dset1 = 1,1,1,1,1,1,1,1 & dset2 = 0,0,0,0,0,0,0,0
%           L = 2 & multiline = false
%           the resulting file will have: 1100110011001100
% ARGS:
%   dset1 & dset2:  {1 x n num} - arrays to be merged
%   L: {int} - number of datapoints per slice
%   multiline: {bool} - put each slice in a new line?
%   fName: {String} - name of the file with extension
% OUTPUTS:
%   dataset: {a x b double} - the merged dataset
% PRECONDITIONS:
%   dset1 and dset2 have dimensions 1 x n, n an int.
%   rem(n, L) == 0;
%       - if it isn't, the number of elements required will be removed from
%       both datasets, removing from the end. 

    % check preconditions
    if ~isequal(size(dset1),[1, size(dset1, 2)]) || ~isequal(size(dset2),[1, size(dset2, 2)])
        error('One or more of the datasets has incorrect dimensions. Should be 1 x n');
    end
    
    if size(dset1, 2) ~= size(dset2, 2)
        error('Dataset sizes are not equal');
    end
    
    % get the size now that we know they are equal
    n = size(dset1, 2);
    if rem(n, L) ~= 0
        %remove the last few elements to make it divisible. 
        disp('WARNING: Cannot create lines of L size from given datasets. Stipping end');

        dset1 = dset1(1, 1:n-rem(n, L));
        dset2 = dset2(1, 1:n-rem(n, L));
    end
    
    % reshape into slices
    dset1 = reshape(dset1, L, []);
    dset2 = reshape(dset2, L, []);
    
    % merge
    dataset = reshape([dset1;dset2], size(dset1,1), [])';
    
    % if we don't need multiline then reshape again to make it singleline
    if ~multiline
        dataset = reshape(dataset', 1, []);
    end
    
end

