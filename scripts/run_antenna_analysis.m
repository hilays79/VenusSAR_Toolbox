% Analysis: Antenna Pattern Plot
clear; clc; close all;

look_angle = 30;
[gain, angle] = sar.Antenna.getPattern(look_angle);

figure('Name', 'Antenna Pattern', 'Color', 'w');
plot(angle, gain, 'LineWidth', 1.5);
xlabel('Angle (deg)'); 
ylabel('Gain (dB)');
title(['Antenna Pattern @ ' num2str(look_angle) ' deg Look Angle']);
grid on; 
xlim([look_angle-10, look_angle+10]);
