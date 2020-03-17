fly_data = load('fly_data.mat').fly_data;

%timestamps x channels x trials x condition
fly_1_ch_15 = squeeze(fly_data(:, 15, :, 1, :));


%concatenate into timestamps x trials, with awake then anesthesia
fly_1_ch_15_cat = cat(2, squeeze(fly_1_ch_15(:,:,1)), squeeze(fly_1_ch_15(:,:,2)));


%%discretise by binary diff
diffed = diff(fly_1_ch_15_cat);
diffed(diffed > 0) = 1;
diffed(diffed <= 0) = 0;

%rearrange to meet run_CSSR and dataset merger needs
diffed = permute(diffed, [2,1]);
%%
%merge dataset
merged = squeeze(create_dataset_from_n_binary_sets(diffed));
decimal = convert_binary_to_decimal(merged);
single_char_mat = arrayfun(@(x) dec2hex(x), decimal);

%% build epsilon machine
fName = 'eM_all_fly_1_ch15';
for L = 1:15
    run_CSSR(diffed, 'binary01-alphabet.txt', L, 0.005, fName);
end
%%
%get TPM from e-machine
dotFName = strcat(fName, 'L', num2str(L), '_inf.dot');
TPM = get_TPM_from_dot(dotFName);
TPM(isnan(TPM)) = 0;
TPM = TPM + TPM';
%find minimum cut using stoer and wagner implementation
%NOTE: I HAVEN'T TESTED THIS IMPLEMENTATION THOROUGHLY, 
%WHICH WAS FOUND ON MATLAB FILE EXCHANGE. 
[mv, mw] = mincut(TPM, 1);
