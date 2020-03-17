function frequencies_per_timewindow = frequency_analysis_per_epoch(n_windows, fName)
    % reads a state series file for a given fName and calculates
    % frequencies per timewindow of each epoch, returning them in a cell 
    disp(fName);
    D = readmatrix(fName, "Delimiter", ";");
    D = D(:,~any(isnan(D)));

    states = transpose(unique(D));

    % partition into time series
    
    matrix_timepoints = size(D, 2);
    matrix_epochs = size(D, 1);
    window_size = matrix_timepoints/(0.5 + n_windows/2);
    
    frequencies_per_timewindow = cell(1, n_windows);
    count = 1;
    for i = 1:window_size/2:matrix_timepoints - window_size/2
        frequencies_per_epochs = cell(1, matrix_epochs);
        for j = 1:matrix_epochs
            current_epoch = D(j, fix(i):fix(i+window_size - 1));
            % turn fs to categorical with char column to avoid 0 frequency states
            fs = tabulate(categorical(current_epoch));
            fs = fs(:, 1:2);
            
            fs = [str2double(fs(:, 1)), cell2mat(fs(:, 2))];
            %add 0 frequency for causal states not in this epoch
            for k = states
                if ~any(fs(:, 1) == k)
                fs = [fs; [k 0]];
                end
            end
            frequencies_per_epochs{1, j} = sortrows(fs);
        end
        frequencies_per_timewindow{1, count} = frequencies_per_epochs;
        count = count + 1;
    end
    

end