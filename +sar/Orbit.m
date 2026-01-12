classdef Orbit
    % ORBIT Handles orbital mechanics and velocity calculations
    
    methods (Static)
        function v = getVelocity(altitude)
            % Calculates orbital velocity at given altitude(s)
            % Input: altitude (meters)
            
            mu = sar.Config.GravitationalConst * sar.Config.PlanetMass;
            R = sar.Config.PlanetRadius;
            a = sar.Config.getSemiMajorAxis();
            
            % Vis-viva equation
            v = sqrt(mu * ((2 ./ (R + altitude)) - (1/a)));
        end
        
        function dbw = getDopplerBandwidth(velocity, antenna_length)
            dbw = 2 * velocity / antenna_length;
        end
    end
end
