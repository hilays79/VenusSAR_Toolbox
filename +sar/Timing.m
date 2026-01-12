classdef Timing
    % TIMING Handles PRF selection, Eclipse check, and Nadir interference
    
    methods (Static)
        function [prf_matrix, prf_axis] = calculateValidPRF(h_array, look_angle, tau, prf_min, prf_max)
            % Implements the exact eclipse and nadir logic from PRF_heighter.m
            % Returns a matrix (Height x PRF) where invalid entries are NaN
            
            if nargin < 4, prf_min = 1500; end
            if nargin < 5, prf_max = 9000; end
            
            prf_axis = linspace(prf_min, prf_max, 5501);
            c = sar.Config.LightSpeed;
            swath = sar.Config.SwathWidth;
            
            num_h = length(h_array);
            num_prf = length(prf_axis);
            prf_matrix = nan(num_h, num_prf);
            
            % Vectorized parameters
            t_nadir = 2 * h_array / c;
            
            for i = 1:num_h
                h = h_array(i);
                
                [r_near, r_far] = sar.Geometry.getSwathExtents(h, look_angle, swath);
                
                t_near = 2 * r_near / c;
                t_far = 2 * r_far / c;
                
                % Limit N search space
                % N is the pulse index. We assume N can go high enough to cover the window.
                
                for k = 1:num_prf
                    current_prf = prf_axis(k);
                    
                    % --- 1. Transmit Eclipse Check ---
                    % Check if the echo window [t_near, t_far] falls clearly between two pulses
                    is_eclipse_valid = false;
                    
                    % Heuristic to find N quickly: N ~ prf * t_near
                    n_guess = floor(current_prf * (t_near - tau)); 
                    
                    % Check neighborhood of guess
                    for n = n_guess:n_guess+2
                        if n < 1, continue; end
                        
                        % Logic: PRF must be > (N-1)/(t_start - tau) AND < N/(t_end + tau)
                        lhs = (n-1) / (t_near - tau);
                        rhs = n / (t_far + tau);
                        
                        if (current_prf > lhs) && (current_prf < rhs)
                            is_eclipse_valid = true;
                            break;
                        end
                    end
                    
                    if ~is_eclipse_valid
                        continue; % Leave as NaN and skip to next PRF
                    end
                    
                    % --- 2. Nadir Interference Check ---
                    % Logic strictly followed from PRF_heighter.m
                    
                    % M is the pulse index relative to the nadir delay
                    m_val = floor((t_near - t_nadir(i)) * current_prf) + 1;
                    
                    nadir_lhs = (m_val - 1) / (t_near - tau - t_nadir(i));
                    nadir_rhs = m_val / (t_far + tau - t_nadir(i));
                    
                    % Original logic: if PRF is between these bounds, it is VALID.
                    % Otherwise (if lt LHS or gt RHS), it is INVALID.
                    
                    if (current_prf > nadir_lhs) && (current_prf < nadir_rhs)
                        prf_matrix(i, k) = current_prf;
                    else
                        prf_matrix(i, k) = NaN;
                    end
                end
            end
        end
    end
end
