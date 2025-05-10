function [count, winners, elapsedTime] = parCheck_c(dt, n, n_fill, V_f) %#codegen
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
%   count       The number of laminate designs that pass the strength and stiffness check
%   winners     A countxn array containing the layups that pass the check
%
% Dependencies:
%   t_from_Vf
%   build_angle_combos
%   laminate_stiffness
%   strengthCheck
%   stiffnessCheck
%
% Note:
%   This version of the function is intended for use with MATLAB Coder to compile into C code.
%
% Searches all possible symmetric layups for a given number of plies and volume fraction,
% and returns those that pass both the strength and stiffness checks.

    arguments
        dt (1,1) double
        n  (1,1) double
        n_fill (1,1) double
        V_f (1,1) double
    end

    % Carbon Fibers
    E_1f = 270e3; % MPa
    E_2f = 14e3; % MPa
    G_12f = 10e3; % MPa
    nu_12f = 0.22; %

    % Epoxy Matrix
    E_m = 3.5e3; % MPa
    nu_m = 0.37;
    xi_1 = 1;
    xi_2 = 1;

    % Form input vectors
    fiber_properties = [E_1f, E_2f, G_12f, nu_12f];
    matrix_properties = [E_m, nu_m];
    t = t_from_Vf(V_f);
    composite_properties = [V_f, xi_1, xi_2];

    % Define the thetas to be searched:

    thetas = (-90 + dt):dt:90;

    % Generate mid layers vector
    mid_layers = 90 * ones(1, n_fill);

    % Get all possible angle combinations:
    [angle_combinations, num_combinations] = build_angle_combos(thetas);
    tic
    count = 0;
    winners = [];
    for i = 1:num_combinations
        layup_angles = angle_combinations(i, :);

        % Construct the layup with varying and fixed angles
        layup = deg2rad([0, 0, layup_angles, mid_layers, layup_angles(end:-1:1), 0, 0]);

        strength_pass = strengthCheck(layup, V_f);

        [~,~,ABD] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, layup, t);
        stiff_pass = stiffnessCheck(ABD);

        % if strength_pass
        %     fprintf("Passed strength check after %0.2f sec.\n", toc)
        % end
        %
        % if sum(stiff_pass) == 4
        %     fprintf("Passed stiffness check after %0.2f sec.\n", toc)
        % end

        if strength_pass && (sum(stiff_pass) == 4)
            fprintf("Winner Found after %0.2f sec.\n", toc)
            disp(layup)
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
