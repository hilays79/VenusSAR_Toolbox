classdef Antenna
    % ANTENNA Generates antenna gain patterns
    
    methods (Static)
        function [gain_db, angles_deg] = getPattern(look_angle_deg)
            % Recreates the antenna pattern logic from AntennaPattern.m
            
            % Constants
            cfg = sar.Config;
            lambda = cfg.getWavelength();
            W = cfg.AntennaWidth;
            
            % Setup angular space
            bore_rad = deg2rad(look_angle_deg);
            look_rad = (bore_rad - pi):0.0001:(bore_rad + pi);
            
            % Beamwidths (using 0.89 factor from original code)
            rbw = 0.89 * lambda / W;
            
            % Note: Original code used N = 1/(0.7*Rbw)
            N = 1 / (0.7 * rbw);
            
            phi = look_rad - bore_rad;
            u = N * pi * 0.7 * sin(phi);
            
            % Sinc squared pattern
            g_linear = (sin(u)./u).^2;
            
            % Handle singularity at u=0
            g_linear(isnan(g_linear)) = 1;
            
            gain_db = pow2db(g_linear);
            angles_deg = rad2deg(look_rad);
        end
    end
end
