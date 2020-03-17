%% Load 
sleep_data = load('ffMS217_stages.mat');
wake = sleep_data.wake_activity;
n3 = sleep_data.n3_activity;
% index 20 is Cz, most central channel. 
cz = 9;
wake_cz = squeeze(wake(:, cz, :));
n3_cz = squeeze(n3(:, cz, :));

together = [wake_cz;n3_cz];

%% downsample
downsample_rate = 100;  %  take average of blocks of 100 values per row
means = zeros(size(together, 1), size(together, 2)/downsample_rate);
counter = 1;
for k = 1:downsample_rate:size(together, 2)
    disp([k, k + downsample_rate - 1]);
    means(:, counter) = mean(together(:, k: k + downsample_rate - 1), 2);
    counter = counter + 1;
end
%% binarise
medians = median(together, 2);
median_splits = zeros(size(together));
for i = 1:size(together,1)
    for j = 1:size(together, 2)
        if together(i,j) > medians(i)
            median_splits(i,j) = 1;
        end
    end
end

%% diff
diffed = diff(together, 1, 2);
diffed(diffed > 0) = 1;
diffed(diffed <= 0) = 0;

%% Do eM
FNAME = 'sleep_aw_n3_medsplit_1_428_t3';
LMAX = 3;
comp = run_CSSR(median_splits([1 428], :), 'alphabet.txt', LMAX, 0.005, FNAME, true);
fname_dot = strcat(FNAME,'L', num2str(LMAX), '_inf.dot');
[TPM, emissions] = get_TPM_and_emissions_from_dot(fname_dot);

TPM(isnan(TPM)) = 0;
%%
[gs, ps] = get_strongly_connected_bipartitions(TPM);

% analyse the frequency
A = readmatrix(strcat(FNAME, 'L', num2str(LMAX), '_state_series'));
freq_table = tabulate(reshape(A, [], 1));