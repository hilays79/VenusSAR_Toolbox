classdef Performance
    % PERFORMANCE Calculates NESZ, Data Rate, and system metrics
    
    methods (Static)
        function nesz_db = getNESZ(altitude, look_angle, prf, tau, peak_power)
            cfg = sar.Config;
            [~, R, ~] = sar.Geometry.getParameters(altitude, look_angle);
            v = sar.Orbit.getVelocity(altitude);
            lambda = cfg.getWavelength();
            
            % Antenna Gain (Boresight approx)
            eff = 0.5;
            G0 = 4 * pi * (cfg.AntennaLength * cfg.AntennaWidth) / (lambda^2) * eff;
            
            kT = cfg.BoltzmannConst * cfg.SystemTemp;
            
            P_avg = peak_power .* prf .* tau;
            
            % Radar Equation (dB summation method)
            % NESN = (R^3 * V * sin(inc) * ... ) / (Pavg * G^2 * lambda^3 * SRR)
            
            R_db = 30*log10(4*pi*R);
            V_db = 10*log10(2*v.*sind(look_angle));
            Noise_db = 10*log10(kT);
            G_db = 20*log10(G0);
            wl_db = 30*log10(lambda);
            srr_db = 10*log10(20); % Fixed SRR 20m
            P_avg_db = 10*log10(P_avg);
            
            nesz_db = (R_db + V_db + Noise_db + cfg.SystemLossdB) - ...
                      (P_avg_db + G_db + wl_db + srr_db);
        end
        
        function rate_mbps = getDataRate(altitude, look_angle, prf, tau)
            [r_near, r_far] = sar.Geometry.getSwathExtents(altitude, look_angle, sar.Config.SwathWidth);
            c = sar.Config.LightSpeed;
            
            bft = 2 * (r_far - r_near) / c;
            data_window = tau + bft;
            
            SRR = 20;
            bw = c / (2 * SRR);
            fs = 1.2 * bw;
            bits = 8;
            
            rate_mbps = (data_window .* fs .* prf * bits * 2) / 1e6;
        end
    end
end
