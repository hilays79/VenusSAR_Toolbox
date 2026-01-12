classdef Data
    % DATA Helper class to load specific .mat files from the data/ directory
    
    properties (Constant)
        % Exact filenames from your screenshot
        FILE_SIGMA = 'venus_HH_VV_sigma_S_band_SAR.mat';
        FILE_PRF_TABLE = 'PRF_table_final_Dbw.mat';
        FILE_OPT_PARAMS = 'opt_az_par.mat';
    end
    
    methods (Static)
        function data = loadSigmaData()
            % Loads the Sigma0 data (HH_sigma, theta)
            fpath = fullfile('data', sar.Data.FILE_SIGMA);
            if ~isfile(fpath)
                error('Data file not found: %s. Please put it in the /data folder.', fpath);
            end
            data = load(fpath);
        end
        
        function data = loadPRFTable()
            % Loads the optimized PRF table
            fpath = fullfile('data', sar.Data.FILE_PRF_TABLE);
            if ~isfile(fpath)
                error('Data file not found: %s', fpath);
            end
            data = load(fpath);
        end
        
        function data = loadOptParams()
            % Loads optimization parameters (opt_az_par)
            fpath = fullfile('data', sar.Data.FILE_OPT_PARAMS);
            if ~isfile(fpath)
                error('Data file not found: %s', fpath);
            end
            data = load(fpath);
        end
    end
end
