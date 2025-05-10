function [angle_combinations, num_combinations] = build_angle_combos(thetas, n, n_fill)
% build_angle_combos.m
%
% Generates all possible combinations of ply angles for symmetric laminate layups,
% given the number of plies, allowable angles, and number of fixed mid-layers.
%
% Inputs:
%   thetas              Vector of allowable ply angles (in degrees)
%   n                   Total number of lamina in the laminate
%   n_fill              Number of mid-layers to keep fixed (not varied).
%                       If n is odd/even, n_fill must also be odd/even.
%
% Outputs:
%   angle_combinations  Array containing all possible combinations of angle orientations
%                       to be checked (each row is a combination)
%   num_combinations    The number of possible combinations
%
% Dependencies:
%   None (uses only internal calculations)
%
% Notes:
%   - Enforces symmetry about the laminate mid-plane.
%   - When compiling with MATLAB Coder for C code, you must set num_varying_angles
%     (the number of lamina to be varied) as a fixed constant in the code, rather than
%     computing it dynamically. Set this value to match the number of lamina you wish
%     to vary in your compiled C code.
%   - For MATLAB Coder: Comment out the first (dynamic) section of code and uncomment
%     the last (fixed-size) section before compiling.

    % Enforce one zero layer in odd lamina count laminates
    if n_fill == 0
        if rem(n,2) ~= 0
            n_fill = 1;
        end
    end

    % compute the number of angles to be varied; this is half the number of lamina being varied because symmetry is enforced across the mid layers.
    num_varying_angles = 0.5 * (n - n_fill);

    % enforce whole numbers of lamina
    if rem(num_varying_angles,1) ~= 0
        error("Odd lamina counts require odd fixed mid-layers; Even lamina counts require even fixed mid-layers.")
    end

    num_angles = length(thetas); % Number of allowable angles
    num_combinations = num_angles^num_varying_angles; % The total number of combinations

    % Generate all combinations using ndgrid
    grids = cell(1, num_varying_angles);
    [grids{:}] = ndgrid(1:num_angles);
    idx_matrix = cellfun(@(x) x(:), grids, 'UniformOutput', false);
    idx_matrix = [idx_matrix{:}]; % Each row is a combination of indices

    angle_combinations = thetas(idx_matrix); % Map indices to angles


    % % --- CODEGEN COMPATIBLE VERSION: num_varying_angles fixed at 8 ---
    % num_varying_angles = 5;
    % num_angles = length(thetas);
    % num_combinations = num_angles^num_varying_angles;

    % idx_matrix = zeros(num_combinations, num_varying_angles);
    % for i = 1:num_combinations
    %     idx = i - 1;
    %     for j = num_varying_angles:-1:1
    %         idx_matrix(i, j) = mod(idx, num_angles) + 1;
    %         idx = floor(idx / num_angles);
    %     end
    % end
    % angle_combinations = thetas(idx_matrix);
end
