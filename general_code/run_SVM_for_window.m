function [accuracy, tp] = run_SVM_for_window(dataset, window_n, L_Max, cost, n_epochs)
    % specific only to dataset with first half epochs being face, second
    % half nonface. 
    freqs_timewindow = dataset;

    window = freqs_timewindow{window_n, 1};
    %n_epochs = size(window, 2);
    half_n = fix(n_epochs/2);
    
    epochs_70 = round(half_n * 0.7);
    epochs_30 = half_n - epochs_70;
    %try
        %extract training set
        %convert to a m rows x n columns format with m instances and n features
        % set_split_face = {1:66; 67:94};
        % set_split_nonface = {95:160; 161:188};

        % extract training and testing sets randomly
        face_perm = randperm(half_n);
        nonface_perm = randperm(half_n);

        set_split_face = {face_perm(1:epochs_70); face_perm(epochs_70 + 1:half_n)};
        set_split_nonface = {half_n + nonface_perm(1:epochs_70); half_n + nonface_perm(epochs_70 + 1:half_n)};
        training_epochs = [set_split_face{1} set_split_nonface{1}];
        training_matrix = [];
        
        for i = training_epochs
            horiz_train = [];
            for ch = 1:size(window, 1)
                epoch = window{1, i};
                freq = normalize(transpose(epoch(:, 2)));
                horiz_train = [horiz_train freq];
            end
            training_matrix = [training_matrix;horiz_train];
        end
        tp = training_matrix;
        % set training labels
        %first half are face, second half nonface
        training_labels = transpose([ones(1,size(training_matrix, 1)/2) zeros(1,size(training_matrix, 1)/2)]);

        %make training instance sparse
        training_matrix = sparse(training_matrix);
        disp(num2str(cost))
        model = train(training_labels, training_matrix, ['-s 1', strcat('-c ', num2str(cost))]);

        % test matrix creation
        testing_epochs = [set_split_face{2} set_split_nonface{2}];
        testing_matrix = [];
        for j = testing_epochs
            horiz_test = [];
            for cht = 1:size(window, 1)
                epoch = window{1, j};
                freq = normalize(transpose(epoch(:, 2)));
                horiz_test = [horiz_test freq];
            end
            testing_matrix = [testing_matrix; horiz_test];
        end

        testing_matrix = sparse(testing_matrix);
        %test labels
        testing_labels = transpose([ones(1,size(testing_matrix, 1)/2) zeros(1,size(testing_matrix, 1)/2)]);

        [predicted_label, accuracy, prob_estimates] = predict(testing_labels, testing_matrix, model);

    %catch
        %accuracy = NaN;
    %end
end