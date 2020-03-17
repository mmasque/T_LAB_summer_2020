everything = load("all_channels_face_nonface_epochs.mat");
chA = squeeze(everything.overall(:, 29, :));

plt = imagesc(chA(:, :));
set(gca, 'XTick', [1:373/11:374], 'XTickLabel', [-300:100:800]);% 
colormap(colorcube(2));