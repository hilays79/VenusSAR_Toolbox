classdef Ambiguity
    % AMBIGUITY Handles Range (RASR) and Azimuth (AASR) calculations
    
    methods (Static)
        function [rasr_db, swath_axis] = calculateRASR(h, look_angle_deg, prf)
            % Replicates the logic from RangeAmbgpaperHeight.m
            % h: Single altitude (m)
            % look_angle_deg: Look angle (deg)
            % prf: PRF (Hz)
            
            cfg = sar.Config;
            R = cfg.PlanetRadius;
            
            % Load Sigma Data
            sig_data = sar.Data.loadSigmaData();
            sigma_ref_theta = sig_data.theta; % Array of angles
            sigma_ref_hh = sig_data.HH_sigma; % Array of dB values
            
            % Setup Geometry
            [~, ~, ground_range_center, ~] = sar.Geometry.getParameters(h, look_angle_deg);
            
            % Swath Points
            num_points = 100;
            swath_axis = linspace(-cfg.SwathWidth/2, cfg.SwathWidth/2, num_points);
            gr_vec = ground_range_center + swath_axis;
            
            % Calculate main parameters across swath
            gamma_vec = gr_vec / R;
            slant_range_vec = sqrt(R^2 + (R+h)^2 - 2*R*(R+h)*cos(gamma_vec));
            look_angle_vec = asin(R*sin(gamma_vec)./slant_range_vec); % radians
            inc_angle_vec = gamma_vec + look_angle_vec; % radians
            
            % Timing
            c = cfg.LightSpeed;
            tau_vec = 2 * slant_range_vec / c;
            
            rasr_linear = zeros(1, num_points);
            
            % Antenna Gain
            eff = 0.5;
            G0 = ((4*pi*cfg.AntennaLength*cfg.AntennaWidth) / cfg.getWavelength()^2) * eff;
            
            for i = 1:num_points
                % Main signal
                main_look = look_angle_vec(i);
                main_gain = sar.Antenna.getGainAtAngle(main_look, deg2rad(look_angle_deg)) * G0;
                
                % Interpolate Sigma0 for main signal
                main_inc_deg = rad2deg(inc_angle_vec(i));
                main_sigma_db = interp1(sigma_ref_theta, sigma_ref_hh, main_inc_deg, 'linear', 'extrap');
                main_sigma = 10^(main_sigma_db/10);
                
                main_power = (main_gain^2 * main_sigma) / (slant_range_vec(i)^4);
                
                % Aliased signals
                % Find pulses before and after
                % Logic: Find range ambiguities at t_echo +/- n*PRI
                pri = 1/prf;
                t0 = tau_vec(i);
                
                ambig_power_sum = 0;
                
                % Check n from -10 to 10 (sufficient for near-ambiguities)
                for n = [-9:-1, 1:9] 
                    t_amb = t0 + n*pri;
                    if t_amb <= 0, continue; end
                    
                    r_amb = t_amb * c / 2;
                    
                    % Check if r_amb intersects planet
                    % Cosine rule inverse to find gamma_amb
                    % r^2 = R^2 + (R+h)^2 - 2R(R+h)cos(gamma)
                    % cos(gamma) = (R^2 + (R+h)^2 - r^2) / (2R(R+h))
                    
                    cos_gamma = (R^2 + (R+h)^2 - r_amb^2) / (2*R*(R+h));
                    
                    if abs(cos_gamma) > 1
                        continue; % Ray does not hit planet surface
                    end
                    
                    gamma_amb = acos(cos_gamma);
                    
                    % Look angle for ambiguity
                    % sin(look) / R = sin(gamma) / r
                    sin_look_amb = R * sin(gamma_amb) / r_amb;
                    look_amb = asin(sin_look_amb);
                    
                    % Distinction between left/right looking? 
                    % Ambiguities can come from "negative" angles in antenna pattern
                    % Logic from original code: `Look_Angle_Ambg_neg = fliplr(-Look_Angle_Ambg)`
                    % We check both +Look and -Look (Left/Right ambiguity)
                    
                    for sign_look = [-1, 1]
                        real_look_amb = sign_look * look_amb;
                        
                        % Antenna Gain at ambiguity
                        gain_amb = sar.Antenna.getGainAtAngle(real_look_amb, deg2rad(look_angle_deg)) * G0;
                        
                        % Incidence Angle
                        inc_amb = gamma_amb + look_amb; % Scalar geometry
                        inc_amb_deg = rad2deg(inc_amb);
                        
                        % Sigma0
                        sig_amb_db = interp1(sigma_ref_theta, sigma_ref_hh, inc_amb_deg, 'linear', 'extrap');
                        sig_amb = 10^(sig_amb_db/10);
                        
                        p_amb = (gain_amb^2 * sig_amb) / (r_amb^4);
                        ambig_power_sum = ambig_power_sum + p_amb;
                    end
                end
                
                rasr_linear(i) = ambig_power_sum / main_power;
            end
            
            rasr_db = 10*log10(rasr_linear);
        end
    end
end
