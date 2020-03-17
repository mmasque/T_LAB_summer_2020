before_downsample = load('subject_153_time_bin_3_voltage.mat').data_before_down_sample;

cABCD = [29, 30, 8, 9];

c_abcd_data = before_downsample(:, cABCD, :);

%% get difference and binarise
diffed = diff(c_abcd_data, 1, 1);
diffed(diffed <= 0) = 0;
diffed(diffed > 0) = 1;

binarised = diffed;

%% join datasets from channels A, B, C, D
[results, alphabet] = create_dataset_from_n_binary_sets(binarised);

dec_results = convert_binary_to_decimal(squeeze(results));

%we can only use single character for each alphabet member. '10' doesn't
%work
single_char_mat = arrayfun(@(x) dec2hex(x), dec_results);
alphabet = dec2hex(alphabet);
%create_alphabet_file
%convert_dataset_to_textfile(transpose(alphabet), "Four_ch_alphabet");