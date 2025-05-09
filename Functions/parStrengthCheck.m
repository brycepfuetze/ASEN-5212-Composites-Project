function [count, winners, elapsedTime] = parStrengthCheck(dt, n, n_fill, V_f)
% Inputs:
%   dt      Theta step size in degrees
%   n       The number of lamina in in the laminate being designed.
%   n_fill  The number of lamina in the center of the laminate that should 
%           not be varried, but kept zero. If n is (odd/even) then n_fill 
%           needs to be (odd/even).
%   elapsedTime time it took in seconds
%
% Outputs:
%   count   The number of laminate designs that pass the strength check
%   winners A nxcount array containing the layups that pass the check

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
    mid_layers = zeros(1, n_fill);
    
    % Get all possible angle combinations:
    [angle_combinations, num_combinations] = build_angle_combos(thetas, n, n_fill);
    tic
    count = 0;
    winners = [];
    parfor i = 1:num_combinations
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