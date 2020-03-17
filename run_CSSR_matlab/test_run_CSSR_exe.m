load("all_channels_face_nonface_epochs.mat")

DATA = overall(:, 1, :);

run_CSSR(DATA, "binary01-alphabet.txt", 3, 0.02, "test_CSSR");

