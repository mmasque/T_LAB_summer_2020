%% range 2^-50 to 2^20 with steps of 2^5

cost_range_pwr = -50:5:20;
window_n = 7;

cost_cells = cell(numel(cost_range_pwr), 1);
for i = 1:numel(cost_range_pwr)
    cost = 2^(cost_range_pwr(i));
    accuracies_over_L = cell(4, 1);
    for l = 2:4
        cv_accuracies = [];
        for j = 1:10    %cross_validation
            acc = run_SVM_for_window(window_n, l, cost);
            cv_accuracies = [cv_accuracies acc(1)];
        end
        accuracies_over_L{l, 1} = cv_accuracies;
    end
    cost_cells{i, 1} = accuracies_over_L;
end

%% get avg and std
avgs_over_L = cell(4, 1);
stds_over_L = cell(4, 1);
for m = 2:4
    avgs = [];
    stds = [];
    for k = 1:numel(cost_cells)
        data = cost_cells{k, 1}{m, 1};
        avg = mean(data);
        stdev = std(data);
        avgs = [avgs avg];
        stds = [stds stdev];
    end
    avgs_over_L{m, 1} = avgs;
    stds_over_L{m, 1} = stds;
end

%% plot averages and std
for p = 2:4
    figure;
    hold on
    xlabel("Cost (2^X)");
    ylabel("Classification accuracy (%)");
    title({"Classification accuracy at sliding time window 300-500 from single eMachine",strcat("mean over cross validation, maximum history length ", num2str(p)), 'classifier run on training data'});
    errorbar(cost_range_pwr, avgs_over_L{p, 1}, stds_over_L{p, 1});
    hold off
end

