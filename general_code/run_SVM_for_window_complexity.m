function [accuracy] = run_SVM_for_window_complexity(window_n, L_Max, cost)

    A = load("complexities_4_epoch_em_empties_removed.mat");

    complexities_per_length = A.complexities_per_length;

    %extract the data for the correct L_Max and window number
    data = complexities_per_length{L_Max, 1}{window_n, 1};
    size(data)
    %there are 47 eMs with 4 epochs per eM.
    %so 23 eMs are face, 1 is both, and 23 eMs are nonface

    face_perm = randperm(23);
    nonface_perm = randperm(23);

    %approx 16 epochs constitute 70%
    set_split_face = {face_perm(1:16); face_perm(17:23)};
    set_split_nonface = {24 + nonface_perm(1:16); 24 + nonface_perm(17:23)};
    training_epochs = [set_split_face{1} set_split_nonface{1}];
    training_matrix = [];

    for i = training_epochs
        epoch = data{i, 1};
        training_matrix = [training_matrix;epoch];
    end
    training_labels = transpose([ones(1,size(training_matrix, 1)/2) zeros(1,size(training_matrix, 1)/2)]);

    %make training instance sparse
    training_matrix = sparse(training_matrix);
    disp(num2str(cost))
    model = train(training_labels, training_matrix, ['-s 1', strcat('-c ', num2str(cost))]);

    % test matrix creation
    testing_epochs = [set_split_face{2} set_split_nonface{2}];
    testing_matrix = [];
    for j = testing_epochs
        epoch = data{j, 1};
        testing_matrix = [testing_matrix;epoch];
    end

    testing_matrix = sparse(testing_matrix);
    %test labels
    testing_labels = transpose([ones(1,size(testing_matrix, 1)/2) zeros(1,size(testing_matrix, 1)/2)]);

    [predicted_label, accuracy, prob_estimates] = predict(testing_labels, testing_matrix, model);

