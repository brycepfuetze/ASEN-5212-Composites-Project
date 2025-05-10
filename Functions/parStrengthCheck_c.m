function [count, winners, elapsedTime] = parStrengthCheck_c(dt, n, n_fill, V_f) %#codegen
% Inputs:
%   dt          Theta step size in degrees
%   n           The number of lamina in the laminate being designed.
%   n_fill      The number of lamina in the center of the laminate that should
%               not be varied, but kept zero. If n is (odd/even) then n_fill
%               needs to be (odd/even).
%   V_f         Composite Volume Fraction
%   elapsedTime  Time it took in seconds
%
% Outputs:
%   count       The number of laminate designs that pass the strength check
%   winners     A countxn array containing the layups that pass the check
%
% Dependencies:
%   build_angle_combos
%   strengthCheck
%
% Note:
%   This version of the function is intended for use with MATLAB Coder to compile into C code.
%
% Searches all possible symmetric layups for a given number of plies and volume fraction,
% and returns those that pass the strength check.

    arguments
        dt (1,1) double
        n  (1,1) double
        n_fill (1,1) double
        V_f (1,1) double
    end

    % Define the thetas to be searched:

    thetas = (-90 + dt):dt:90;

    % Generate mid layers vector
    mid_layers = zeros(1, n_fill);

    % Get all possible angle combinations:
    [angle_combinations, num_combinations] = build_angle_combos(thetas, n, n_fill);
    tic
    count = 0;
    winners = [];
    for i = 1:num_combinations
        layup_angles = angle_combinations(i, :);

        % Construct the layup with varying and fixed angles
        layup = deg2rad([layup_angles, mid_layers, layup_angles(end:-1:1)]);

        [Pass] = strengthCheck(layup, V_f);

        if Pass

            count = count + 1;
            winners = [winners;rad2deg(layup)];
            % layup_degrees = rad2deg(layup);
            % disp("Working Laminate Found");
            % disp(layup_degrees);
        end
    end

    elapsedTime = toc;
    fprintf("Found %.0f / %.0f %.0f-lamina layups pass in %.2f seconds.\n",count, num_combinations,n,elapsedTime)
end
