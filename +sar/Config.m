classdef Config
    % CONFIG Configuration parameters for the Venus SAR System
    
    properties (Constant)
        % Physical Constants
        LightSpeed = physconst('lightspeed');
        GravitationalConst = 6.67408e-11;
        BoltzmannConst = 1.38064852e-23;
        
        % Planet Parameters (Venus)
        PlanetRadius = 6051.8e3;      
        PlanetMass = 4.867e24;        
        OrbitPeriapsis = 200e3;       
        OrbitApoapsis = 600e3;        
        
        % SAR System Defaults
        FreqCenter = 2.5e9;           
        AntennaLength = 6;            
        AntennaWidth = 2;             
        SwathWidth = 20e3;            
        SystemTemp = 290;             
        SystemLossdB = 3.8;           
        DutyCycle = 0.09; 
    end
    
    methods (Static)
        function val = getWavelength(freq)
            if nargin < 1, freq = sar.Config.FreqCenter; end
            val = sar.Config.LightSpeed / freq;
        end
        
        function a = getSemiMajorAxis()
            R = sar.Config.PlanetRadius;
            Rp = sar.Config.OrbitPeriapsis;
            Ra = sar.Config.OrbitApoapsis;
            a = (2*R + Ra + Rp) / 2;
        end
    end
end
