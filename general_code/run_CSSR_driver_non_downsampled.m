%% build epsilon machines 
fName = 'non_downsampled_188_epochs_'
for i = 1:4

run_CSSR(face_nonface_epochs_not_downsampled, 'Four_ch_alphabet.txt', i, fName);
end


%% analyse frequencies of epsilon machines
frequency_analyses_200hz = cell(4, 1);
for j = 1:4
    frequencies_per_timewindow_2000hz = frequency_analysis_per_epoch(j, 10, strcat(fName, "L"));
    frequency_analyses_200hz{j, 1} = frequencies_per_timewindow_2000hz
end