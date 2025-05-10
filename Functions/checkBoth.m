function [pass, criteria] = checkBoth(layup, V_f, plot_lever)
% Inputs:
%   layup       Vector of ply angles (in degrees)
%   V_f         Composite Volume Fraction
%   plot_lever  OPTIONAL. When true, the function outputs a nice plot.
%               Default is false.
%
% Outputs:
%   pass        5 Boolean values. true when the input layup passes the
%               test criteria: [Axx Axx_bar Dxx Dyy Tsai-Wu]
%   criteria    Vector containing the Tsai-Wu failure criteria of each input lamina.
%
% Dependencies:
%   t_from_Vf
%   laminate_stiffness
%   stiffnessCheck
%   strengthCheck
%
% Checks both stiffness and strength criteria for a given laminate layup and volume fraction,
% and returns a vector of pass/fail flags for each criterion.
    if nargin < 2
        plot_lever = false;
    end
    %% Constants

    % Carbon Fibers
    E_1f = 270e3; % MPa
    E_2f = 14e3; % MPa
    G_12f = 10e3; % MPa
    nu_12f = 0.22; %

    % Epoxy Matrix
    E_m = 3.5e3; % MPa
    nu_m = 0.37;

    % Form input vectors
    fiber_properties = [E_1f, E_2f, G_12f, nu_12f];
    matrix_properties = [E_m, nu_m];
    xi_1 = 1;
    xi_2 = 1;
    % composite_properties = [V_f, xi_1, xi_2];

    %% Check Stiffness

    composite_properties = [V_f, xi_1, xi_2];
    t = t_from_Vf(V_f);
    [~,~,ABD] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, deg2rad(layup), t);
    stiff_pass = stiffnessCheck(ABD,plot_lever);

    % if plot_lever
    %     A_xx_min = 100000; % N/mm
    %     D_xx_min = 25000; % Nmm
    %     D_yy_min = 15000; % Nmm
    %
    %     figure
    %     plot(V_f,ABD(1,1),'x')
    %     xlabel("$$V_f$$")
    %     ylabel("$$A_{xx}$$")
    %     yline(A_xx_min,'k--')
    %
    %     figure
    %     plot(V_f,ABD(4,4),'x')
    %     xlabel("$$V_f$$")
    %     ylabel("$$D_{xx}$$")
    %     yline(D_xx_min,'k--')
    %
    %     figure
    %     plot(V_f,ABD(5,5),'x')
    %     xlabel("$$V_f$$")
    %     ylabel("$$D_{yy}$$")
    %     yline(D_yy_min,'k--')
    % end

    %% Check Strength

    [strength_pass, criteria] = strengthCheck(deg2rad(layup), V_f,plot_lever);

    pass = [stiff_pass; strength_pass];
end
