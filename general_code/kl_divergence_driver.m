alphabet = load('4_channel_dataset.mat').alphabet;

pd_data = get_probability_dist_from_data('non_downsampled_188_epochs_L1', alphabet);
data_abs_uncertainty = 1 * 10^(-4);
kls = zeros(4,1);
kl_uncertainties = zeros(4, 1);
probdists = cell(4, 1);
for l = 1:4     %different memory lengths
    fPrefix = strcat('non_downsampled_188_epochs_L', num2str(l));
    pd_from_eM = get_probability_dist_from_eM(fPrefix, alphabet);
    probdists{l, 1} = pd_from_eM;
    [kls(l, 1), kl_uncertainties(l, 1)] = kl_divergence(pd_data, pd_from_eM, data_abs_uncertainty);
end

errorbar(kls, kl_uncertainties);
figure;
plot(kls);