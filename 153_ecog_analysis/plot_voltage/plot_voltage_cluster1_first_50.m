voltages = load("subject_153_time_bin_3_voltage.mat");
processed_voltages = voltages.preprocessed_data;

%load the list of epochs that were selected.
chosen = load("chosen_epochs");
selected_epochs = chosen.choices;
chosen_epochs_voltages = processed_voltages(:, :, selected_epochs);

res = load("cluster_numbers_first_50.mat");
GOOD_CLUSTER = res.cluster_of_int;
res = res.res;
channels = 1:50;

chosen_epochs_voltages = chosen_epochs_voltages(:, 1:50, :);
%% Plot 29
x_axes = -300:1100/370:800;
hold on
for j = 1:188
plot(x_axes, diff(chosen_epochs_voltages(:, 29, j)));
end
plot(x_axes, diff(mean(chosen_epochs_voltages(:, 29, :), 3)), "LineWidth", 3)
hold off
%% Plot all and mean
hold on
good_cluster_channels = [];
for i = 1:50
    if res(i) == GOOD_CLUSTER
        good_cluster_channels = [good_cluster_channels i];
    end
end
meaned_good_cluster_voltages = mean(chosen_epochs_voltages(:, good_cluster_channels, :), 3);
plot(x_axes, meaned_good_cluster_voltages)
plot(x_axes, mean(meaned_good_cluster_voltages, 2), "LineWidth", 3);
%% Plot voltage downsampled to fit sliding window.
window_size = fix(372/10);
mean_voltage_sliding_window = [];
for i = 1:window_size:372 - window_size
    mean_voltage_sliding_window = [mean_voltage_sliding_window ...
        mean(mean_voltage(i:(i+window_size)))];
end
x_axes = load("x_axes.mat");
x_axes = x_axes.x_axes;
plot(x_axes, mean_voltage_sliding_window);
hold off


