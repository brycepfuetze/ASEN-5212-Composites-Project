function [passVec] = stiffnessCheck(ABD,plot_lever)
% Inputs:
%   ABD         6x6 laminate stiffness matrix
%   plot_lever  OPTIONAL. When true, the function outputs a plot.
%               Default is false.
%
% Outputs:
%   passVec     4x1 logical vector. Each entry indicates if the laminate passes:
%               [A_xx, A_xx_bar, D_xx, D_yy] criteria.
%
% Dependencies:
%   build_T
%
% Take in an ABD and check if it passes the criteria for Project Part 1.1

    if nargin < 2
        plot_lever = false;
    end

    % Initialize pass flags for each criterion
    Axxpass = 0;
    Axxbarpass = 0;
    Dxxpass = 0;
    Dyypass = 0;

    % Check if A_xx meets minimum requirement
    if ABD(1,1) >= 100000
        Axxpass = 1;
    end

    % Test A_xx in all rotated directions (A_xx_bar)
    Ntest = 50;
    theta = deg2rad(linspace(0,90,Ntest));
    Ayypass = 1;
    for i = 1:Ntest
        T = build_T(theta(i)); % Build transformation matrix
        bigT = [T, zeros(3,3); zeros(3,3), T'];
        ABDrotate = inv(bigT) * ABD * inv(bigT');
        % If any rotated A_xx is too low, fail
        if ABDrotate(1,1) <= 30000
            Ayypass = 0;
        end
    end

    % Set pass flag for A_xx_bar
    if Ayypass == true
        Axxbarpass = 1;
    end

    % Check if D_xx meets minimum requirement
    if ABD(4,4) >= 25000
        Dxxpass = 1;
    end

    % Check if D_yy meets minimum requirement
    if ABD(5,5) >= 15000
        Dyypass = 1;
    end

    % Collect results in output vector
    passVec = [Axxpass;Axxbarpass;Dxxpass;Dyypass];

    % Optionally plot the results
    if plot_lever
        figure
        bar(passVec)
        xticklabels(["$$A_{xx}$$", "$$\bar{A}_{xx}$$", "$$D_{xx}$$", "$$D_{yy}$$"])
    end

end
