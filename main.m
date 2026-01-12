function main()
    % MAIN Driver for Venus SAR Toolbox
    clc;
    fprintf('========================================\n');
    fprintf('      Venus SAR Analysis Toolbox        \n');
    fprintf('========================================\n');
    
    addpath(genpath(pwd));
    
    if ~exist('data/venus_HH_VV_sigma_S_band_SAR.mat', 'file')
        warning('Data files missing in /data folder. Some scripts may fail.');
    end
    
    while true
        fprintf('\nSelect an analysis to run:\n');
        fprintf('1. PRF Selection Analysis (Diamond Plot)\n');
        fprintf('2. Ambiguity Analysis (RASR/AASR)\n');
        fprintf('3. Antenna Pattern Analysis\n');
        fprintf('4. Performance Check (Data Rate/NESZ)\n');
        fprintf('0. Exit\n');
        
        choice = input('Enter choice (0-4): ');
        
        switch choice
            case 1, run('scripts/run_prf_analysis.m');
            case 2, run('scripts/run_ambiguity_analysis.m');
            case 3, run('scripts/run_antenna_analysis.m');
            case 4, run('scripts/run_performance_check.m');
            case 0, fprintf('Exiting.\n'); break;
            otherwise, fprintf('Invalid choice.\n');
        end
    end
end
