function [angle_combinations, num_combinations] = build_angle_combos(thetas, n, n_fill)
%   Inputs:
%       thetas                  A vector containing all allowable orientations, in degrees.
%       n                       The number of lamina in in the laminate being designed.
%       n_fill                  The number of lamina in the center of the laminate that should not be varried, but kept
%                               zero. If n is (odd/even) then n_fill needs to be (odd/even).
%
%   Outputs:
%       angle_combinations      array containing all possible combinations of angle orientations to be checked in
%                               parallel processes.
%       num_combinations        The number of possible combinations

    
    % % Enforce one zero layer in odd lamina count laminates
    % if n_fill == 0
    %     if rem(n,2) ~= 0
    %         n_fill = 1;
    %     end
    % end
    % 
    % % compute the number of angles to be varied; this is half the number of lamina being varied because symmetry is enforced across the mid layers.
    % num_varying_angles = 0.5 * (n - n_fill);
    % 
    % % enforce whole numbers of lamina
    % if rem(num_varying_angles,1) ~= 0
    %     error("Odd lamina counts require odd fixed mid-layers; Even lamina counts require even fixed mid-layers.")
    % end
    % 
    % num_angles = length(thetas); % Number of allowable angles
    % num_combinations = num_angles^num_varying_angles; % The total number of combinations
    % 
    % % Generate all combinations using ndgrid
    % grids = cell(1, num_varying_angles);
    % [grids{:}] = ndgrid(1:num_angles);
    % idx_matrix = cellfun(@(x) x(:), grids, 'UniformOutput', false);
    % idx_matrix = [idx_matrix{:}]; % Each row is a combination of indices
    % 
    % angle_combinations = thetas(idx_matrix); % Map indices to angles
    

    % --- CODEGEN COMPATIBLE VERSION: num_varying_angles fixed at 8 ---
    num_varying_angles = 8;
    num_angles = length(thetas);
    num_combinations = num_angles^num_varying_angles;

    idx_matrix = zeros(num_combinations, num_varying_angles);
    for i = 1:num_combinations
        idx = i - 1;
        for j = num_varying_angles:-1:1
            idx_matrix(i, j) = mod(idx, num_angles) + 1;
            idx = floor(idx / num_angles);
        end
    end
    angle_combinations = thetas(idx_matrix);
end
