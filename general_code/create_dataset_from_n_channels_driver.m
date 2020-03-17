A = load("all_channels_face_nonface_epochs.mat");

data = A.overall;

ABCD = [29, 30, 8, 9];
cABCD_face_nonface_alltimes = (data(:, ABCD, :));

[results, alphabet] = create_dataset_from_n_binary_sets(cABCD_face_nonface_alltimes);

dec_results = convert_binary_to_decimal(squeeze(results));

%we can only use single character for each alphabet member. '10' doesn't
%work
single_char_mat = arrayfun(@(x) dec2hex(x), dec_results);
alphabet = dec2hex(alphabet);
%create_alphabet_file
convert_dataset_to_textfile(transpose(alphabet), "Four_ch_alphabet");