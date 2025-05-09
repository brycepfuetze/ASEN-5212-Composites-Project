function pass = checkBoth(layup, V_f, plot_lever)
% Inputs:
%   layup       Vector of ply angles (in radians)
%   V_f         Composite Volume Fraction
%   plot_lever  OPTIONAL. When true, the function outputs a nice plot.
%               Default is false.
%
% Outputs:
%   pass        5 Boolean values. true when the input layup passes the
%               test criteria: [Axx Axx_bar Dxx Dyy Tsai-Wu]
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
    stiff_pass = stiffnessCheck(ABD);
    
    %% Check Strength
    
    strength_pass = strengthCheck(deg2rad(layup), V_f);
    
    pass = [stiff_pass; strength_pass];
end