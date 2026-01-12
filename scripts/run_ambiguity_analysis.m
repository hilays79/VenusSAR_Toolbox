% Analysis: Range and Azimuth Ambiguity
clear; clc; close all;

h_vec = linspace(200e3, 500e3, 50);
swath_offset = linspace(-10e3, 10e3, 50); 
look_angle = 30;

% Placeholder for RASR Map (Needs full integration logic for precision)
rasr_map = zeros(length(h_vec), length(swath_offset));
for i = 1:length(h_vec)
    rasr_map(i, :) = -30 + 5*cos(swath_offset/5000) + randn(1, length(swath_offset));
end

figure('Name', 'Range Ambiguity', 'Color', 'w');
surf(swath_offset/1e3, h_vec/1e3, rasr_map);
shading interp;
colorbar;
xlabel('Swath Offset (km)');
ylabel('Altitude (km)');
zlabel('RASR (dB)');
title('Range Ambiguity (Simulated)');

% Azimuth Ambiguity Surface
proc_bw_ratio = linspace(0.1, 1, 50);
prf_dbw_ratio = linspace(0.5, 1.5, 50);
aasr_surf = zeros(length(prf_dbw_ratio), length(proc_bw_ratio));

for r = 1:length(prf_dbw_ratio)
    for c = 1:length(proc_bw_ratio)
        ratio = prf_dbw_ratio(r);
        pbw = proc_bw_ratio(c);
        aasr_surf(r, c) = -20 * log10(ratio) + 10*log10(pbw) - 20; 
    end
end

figure('Name', 'Azimuth Ambiguity', 'Color', 'w');
imagesc(proc_bw_ratio, prf_dbw_ratio, aasr_surf);
set(gca, 'YDir', 'normal');
colorbar;
xlabel('Processed BW / PRF');
ylabel('PRF / Doppler BW');
title('Azimuth Ambiguity (Approximation)');
