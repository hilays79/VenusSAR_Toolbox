% Analysis: Data Rate & NESZ
clear; clc; close all;

H = linspace(200e3, 500e3, 301);
look = 30;
tau = 30e-6;
prf_approx = 3500 * ones(size(H)); % Placeholder PRF for trend checking

rate = sar.Performance.getDataRate(H, look, prf_approx, tau);
nesz = sar.Performance.getNESZ(H, look, prf_approx, tau, 200);

figure('Name', 'Performance Metrics', 'Color', 'w');
subplot(2,1,1); 
plot(H/1e3, rate, 'LineWidth', 1.5); 
ylabel('Mbps'); title('Data Rate'); grid on;

subplot(2,1,2); 
plot(H/1e3, nesz, 'LineWidth', 1.5); 
ylabel('NESZ (dB)'); title('NESZ'); grid on; 
xlabel('Altitude (km)');
