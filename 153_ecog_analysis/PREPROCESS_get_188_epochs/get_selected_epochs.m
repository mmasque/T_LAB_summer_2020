B = load("all_channels_face_nonface_epochs.mat");
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
bin = permute(bin, [3,2,1]);

chosen_ones = B.overall;
choices = [];
for i = 1:188
    for j = 1:374
        if bin(j, :, :) == chosen_ones(i, :, :)
            index = j;
        end
    end
    try
    choices = [choices index];
    catch
    end
    
end