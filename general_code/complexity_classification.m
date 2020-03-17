%% build an epsilon machine for each epoch slice in each sliding window
D = transpose(load("face_nonface_not_downsampled.mat").face_nonface_epochs_not_downsampled);
WINDOW_N = 10;
epoch_step = 4;
matrix_timepoints = size(D, 2);
matrix_epochs = size(D, 1);
window_size = matrix_timepoints/(0.5 + WINDOW_N/2);

complexities_per_length = cell(4,1);
for L = 1:2
    complexities_per_timewindow = cell(WINDOW_N, 1);
    for w = 1:WINDOW_N
        complexities_per_epoch = cell(matrix_epochs, 1);
        start = fix(w + (w-1)*(window_size/2 - 1));
        for e = 1:epoch_step:matrix_epochs
            dataset = load_time_window(D, 1, e, epoch_step, start, window_size);
            
            fname = strcat("4_epoch_em_e", num2str(e),"_",num2str(e + epoch_step - 1), "_w", num2str(w), "_");
            try
                complexity = run_CSSR(dataset, 'Four_ch_alphabet.txt', L, fname);
            catch
                complexity = NaN;
            end
            complexities_per_epoch{e, 1} = complexity;
        end
        complexities_per_timewindow{w, 1} = complexities_per_epoch;
    end
    complexities_per_length{L, 1} = complexities_per_timewindow;
end
