A = load('subject_153_time_bin_3.mat');
load('subject_153_epoch_info.mat');

CHANNEL = [29, 30, 8,9];
sampling_rate = 2.0345;
stimulus_onset = 500;
time_start = -300;
time_end = 800;
time_bin_width = 3;

first_sample = round(sampling_rate*(stimulus_onset + time_start)); 
last_sample = round(sampling_rate*(stimulus_onset + time_end));
samples_time_bin = fix(sampling_rate * time_bin_width);

first_time_bin = fix(first_sample/samples_time_bin);
last_time_bin = fix((last_sample - 1) / samples_time_bin);

bin = A.binarised_data(first_time_bin:last_time_bin,:,:);
%%
%there are 94 times when visibility is greater than 2
new = zeros(length(first_time_bin:last_time_bin), size(bin, 2), 192);

visible = [];
for i = 1:192
    if visibility(1, i) > 2
        new(:, :, i) = bin(:, :, i);
        visible = [visible i];
    end
end
c1_all = squeeze(bin(:, 1, :));
bin = bin(:, :, setdiff(1:384, visible));
new = new(:, :, visible);
%select non-visible epochs at random, select a number of them that matches the
%number of visible epochs.
p = randperm(length(bin(1, 1, :)));
rands = p(1:length(visible));
select_nonface = bin(:,:, rands);
%need to create a row for each epoch, 
%with the column indexes being the timeframes. Prior to permuting, 
%the columns were the epoches, and the rows the timeframes. 
reordered_face = permute(new, [3,2,1]); 
reordered_nonface = permute(select_nonface, [3,2,1]);

overall = cat(1, reordered_face, reordered_nonface);
writematrix(overall(:, 1, :), "test_CSSR");
DATA = squeeze(overall(:, 1, :));

%% select 188 from single dataset

face_nonface_epochs_not_downsampled = single_char_mat(:, choices, :);
