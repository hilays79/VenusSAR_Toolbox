classdef Geometry
    % GEOMETRY Handles spherical geometry and slant/ground range conversions
    
    methods (Static)
        function [inc_angle, slant_range, ground_range] = getParameters(altitude, look_angle_deg)
            % Returns geometric parameters based on spherical geometry
            
            R = sar.Config.PlanetRadius;
            look_rad = deg2rad(look_angle_deg);
            
            % Incidence Angle (Sine rule)
            inc_rad = asin((R + altitude) .* sin(look_rad) / R);
            inc_angle = rad2deg(inc_rad);
            
            % Earth/Venus Center Angle
            gamma = inc_rad - look_rad;
            
            % Ground Range
            ground_range = gamma * R;
            
            % Slant Range (Cosine rule)
            slant_range = sqrt(R^2 + (R + altitude).^2 - ...
                2 * R * (R + altitude) .* cos(gamma));
        end
        
        function [near_range, far_range] = getSwathExtents(altitude, look_angle_deg, swath_width)
            % Returns the slant ranges for the near and far edge of the swath
            
            [~, ~, center_gr] = sar.Geometry.getParameters(altitude, look_angle_deg);
            
            R = sar.Config.PlanetRadius;
            gr_near = center_gr - swath_width/2;
            gr_far = center_gr + swath_width/2;
            
            % Convert back to slant range using Law of Cosines
            gamma_near = gr_near / R;
            gamma_far = gr_far / R;
            
            Re = R + altitude;
            
            near_range = sqrt(R^2 + Re.^2 - 2*R*Re.*cos(gamma_near));
            far_range = sqrt(R^2 + Re.^2 - 2*R*Re.*cos(gamma_far));
        end
    end
end
