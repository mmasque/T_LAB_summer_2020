frequencies_for_timewindow = cell(1, 10);
count = 1;
%% bad implementation, see below for better.
for i = [34 67 100 133 166 199 232 265 298 331]
    try
        D = readmatrix(strcat("cABCD_sliding_", num2str(i), "L3_state_series"), "Delimiter", ";");
        D = D(:,~any(isnan(D)));

        states = transpose(unique(D));
        frequencies_per_epochs = cell(1, 188);
        for j = 1:188
            fs = tabulate(D(j, :));
            fs = fs(:, 1:2);
            %add 0 frequency for causal states not in this epoch
            for k = states
                if ~any(fs(:, 1) == k)
                fs = [fs; [k 0]];
                end
            end
            frequencies_per_epochs{1, j} = sortrows(fs);
        end
    catch
        frequencies_per_epochs = NaN;
    end
    frequencies_per_timewindow{1, count} = frequencies_per_epochs;
    count = count + 1;
end

%% better implementation

% load data
D =  load('face_nonface_not_downsampled.mat').face_nonface_epochs_not_downsampled;
D = transpose(D);
%build 10_ems and compute frequencies for each

% settings
n_windows = 10;
matrix_timepoints = size(D, 2);
matrix_epochs = size(D, 1);
window_size = matrix_timepoints/(0.5 + n_windows/2);

frequencies_per_l = cell(1, 3);
%build e-machine per length
for l = 1:3

    frequencies_per_timewindow = cell(1, n_windows);
    %build e-machine per window
    count = 1;
    for j = 1:window_size/2:matrix_timepoints - window_size/2
        j = fix(j);
        fname = strcat('em_cABCD_2000Hz_', num2str(j),"_");
        %build emachine
        run_CSSR(D(:, j:j + window_size-1), 'Four_ch_alphabet.txt', l, fname);
    
        %freq_analysis
        freq = frequency_analysis_per_epoch(l, 1, strcat(fname, "L"));
        freq = freq{1, 1};
        frequencies_per_timewindow{1, count} = freq;
        
        count = count + 1;

    end
    frequencies_per_l{1, l} = frequencies_per_timewindow;
end

