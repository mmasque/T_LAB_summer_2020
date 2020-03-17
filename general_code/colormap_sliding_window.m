load("3d_cABCD_NONFACE_sliding_window.mat")




channel_data = squeeze(separated(:, :, :));
channels = ["A" "B" "C" "D"];
avg_per_channel = mean(channel_data, 3);
plot(x_axes, avg_per_channel(1,:));
%%

t = tiledlayout(4,1);
title(t, "Average complexity over time of L2:L13 for face epochs of channels A, B, C, D");
xlabel(t, "Time(ms)");
ylabel(t, "Average statistical complexity");

for i = 4:-1:1
    disp(i)
    nt = nexttile;
    plot(x_axes, avg_per_channel(i, :), "LineWidth", 1)
    title(nt, channels(i));

end
%%
plt = imagesc(avg_per_channel);
set(gca, 'XTick', [1:10], 'XTickLabel', [-200:100:700]) % 10 ticks
set(gca, 'YTick', [1:4], 'YTickLabel', ["A" "B" "C" "D"])
    
xlabel("Time(ms)");
ylabel("Channel");
c = colorbar;
c.Label.String = "Statistical Complexity";

colormap parula