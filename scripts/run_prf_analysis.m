% Analysis: PRF Selection (The Diamond Plot)
clear; clc; close all;

altitudes = linspace(200e3, 500e3, 301);
look_angle = 30;
tau = 30e-6;

fprintf('Calculating Valid PRFs (Eclipse + Nadir)...\n');
[prf_matrix, prf_axis] = sar.Timing.calculateValidPRF(altitudes, look_angle, tau);

figure('Name', 'PRF Selection', 'Color', 'w');
hold on;

% Plot valid PRF points
for i = 1:length(altitudes)
    valid_idxs = ~isnan(prf_matrix(i, :));
    if any(valid_idxs)
        plot(repmat(altitudes(i)/1e3, sum(valid_idxs), 1), prf_axis(valid_idxs), 'c.', 'MarkerSize', 1);
    end
end

% Plot Min Full-Pol Line
v = sar.Orbit.getVelocity(altitudes);
dbw = sar.Orbit.getDopplerBandwidth(v, sar.Config.AntennaLength);
min_prf = 2.4 * dbw;
plot(altitudes/1e3, min_prf, 'r--', 'LineWidth', 2, 'DisplayName', 'Min Full-Pol PRF');

xlabel('Altitude (km)'); 
ylabel('PRF (Hz)');
title('Available PRF vs Altitude');
grid on; 
xlim([200 500]); 
ylim([1500 5000]);
legend('show');
