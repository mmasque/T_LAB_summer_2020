n_windows = 1; 
flies = {};
for fly = 1:13
    chs = {};
    for ch = 1:15
        means = [];
        stds = [];
        for i = 1:11
            eM_fly_maker(fly, ch, i);
            fName = strcat('eM_fly_', num2str(fly), '_ch_', num2str(ch));
            state_series_name = strcat(strcat(fName,'L', num2str(i), '_state_series'));
            dataset = {fly_data_frequency_driver(state_series_name, 10, i)};
            cross_validation_accuracies = [];
            for u = 1:200
                accuracies = [];
                for j = 1:n_windows
                    [acc, tm] = run_SVM_for_window(dataset, j, i, 1, 160);
                    accuracies = [accuracies acc(1)]
                end
                cross_validation_accuracies = [cross_validation_accuracies; accuracies];
            end
            means = [means mean(cross_validation_accuracies)];
            stds = [stds std(cross_validation_accuracies)];
        end
        chs{1, ch} = means;     
        chs{2, ch} = stds;
    end
    flies{1, fly} = chs;
end

%% plot all color plots, one per fly
for fp = 1:13
    figure;
    f = flies{1, fp};
    
    %convert means cells to a matrix
    f_means_cells = f(1, :);
    % channels by L
    f_means_mat = cell2mat(transpose(f_means_cells));
    fig = imagesc(f_means_mat);
    xlabel('Maximum memory length of eMachine');
    ylabel('Fly channel');
    c = colorbar;
    c.Label.String = "Classification accuracy (%)";

    title({'SVM classification accuracy of eMachine causal state frequencies',...
        strcat('using fly number ', num2str(fp)), 'varying over channels and maximum history length'});
    
    figname = strcat('SVM_classification_fly_n_', num2str(fp), '.png');
    saveas(fig, figname, 'epsc');
end
%% plot central channel
central_channel_mat = [];
%% 
for fp = 1:13
    f = flies{1, fp};
    
    %convert means cells to a matrix
    f_means_cells = f(1, :);
    % channels by L
    f_means_mat = cell2mat(transpose(f_means_cells));
    central_channel_mat = [central_channel_mat; f_means_mat(1, :)];
end
fig = imagesc(central_channel_mat);
%% settings
xlabel('Maximum memory length of eMachine');
ylabel('Fly');
c = colorbar;
c.Label.String = "Classification accuracy (%)";
title({'SVM classification accuracy of eMachine causal state frequencies',...
    'using most central channel data', 'varying over flies and maximum history length'});
figname = strcat('SVM_classification_ch1_all_flies', '.png');
saveas(fig, figname, 'epsc');
%colormap cool
%% get averages and standard deviations
means_over_Ls = cell(11, 1);
stds_over_Ls = cell(11, 1);
for l = 1:11
    means = [];
    stds = [];
    for y = 1:10
        data = accuracies_over_L{l, 1}(:, y);
        mean_ = mean(data);
        std_ = std(data);
        means = [means mean_];
        stds = [stds std_];
    end
    means_over_Ls{l, 1} = means;
    stds_over_Ls{l, 1} = stds;
end

%% plot means and std as bar
x_axes = load("x_axes.mat").x_axes;

hold on
for k = [1:11]
    xlabel("Time from stimulus onset (ms)");
    ylabel("Classification accuracy (%)");
    title({"Classification accuracy at sliding time windows from single eMachine", "with maximum history length 1 - 11","of single channels ", names, " with frequencies combined", "mean over cross validation"});
    errorbar(x_axes, means_over_Ls{k, 1}, stds_over_Ls{k, 1});
end
yline(50, '--');
xline(0, '--');
legend(num2str(transpose(1:11)));
