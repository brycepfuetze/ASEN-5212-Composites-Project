function [Q, S] = calculate_Q_S_matrix(fiber_properties,matrix_properties,composite_properties)
    % calculate_Q_S_matrix.m 
    %
    % ASEN 5112
    % Final Project
    % 8 May 2025
    % 
    % Inputs:
    %     fiber_properties        E_1f, E_2f, G_12f, nu_12f
    %     matrix_properties       E_m, nu_m
    %     composite_properties    V_f, xi_1, xi_2, theta (in radians)
    % 
    % Outputs:
    %     C       Stiffness matrix
    %     S       Compliance matrix


    %% Unpack input variables
    
    E_1f   = fiber_properties(1);
    E_2f   = fiber_properties(2);
    G_12f  = fiber_properties(3);
    nu_12f = fiber_properties(4);
    
    E_m  = matrix_properties(1);
    nu_m = matrix_properties(2);
    
    G_m  = E_m / (2 * (1 + nu_m));
    
    V_f  = composite_properties(1);
    xi_1 = composite_properties(2);
    xi_2 = composite_properties(3);
    theta = composite_properties(4);

    %% Compute values of E, nu, G

    % E1, nu12 rule of mixtures:
    E_1 = E_1f*V_f + E_m*(1-V_f);
    nu_12 = nu_12f * V_f + nu_m*(1-V_f);
    
    % E2, G12 Halpin-Tsai:
    eta_1 = (E_2f - E_m)/(E_2f + xi_1 * E_m);
    E_2 = E_m * (1 + xi_1 * eta_1 * V_f) / (1 - eta_1 * V_f);
    
    eta_2 = ((G_12f/G_m) - 1) / ((G_12f/G_m) + xi_2);
    G_12 = G_m * (1 + xi_2 * eta_2 * V_f) / (1 - eta_2 * V_f);

    % Compute other values
    nu_21 = nu_12 * E_2 / E_1; % symmetry

    
    %% Form S:

    % Form S in 1-2 plane:
    S12 = [1/E_1     -nu_21/E_2 0; ...
        -nu_12/E_1 1/E_2      0; ...
        0          0          1/G_12/2]; % lec. 14 pg 2

    % Build transformation matrix:
    c = cos(theta);
    s = sin(theta);
    T = [ c^2, s^2,  2*c*s; ...
          s^2, c^2, -2*c*s; ...
         -c*s, c*s,  c^2-s^2];

    % Rotate S using T:

    Sxy_temp = T \ S12 * T;

    % Adjust stray values of 2 to get final S matrix:
    Sxy_temp(3,:) = 2 * Sxy_temp(3,:);
    S = Sxy_temp;

    %% Form Q:

    % Build Q in 1-2 plane:
    Q12 = [E_1/(1-nu_12*nu_21), nu_21*E_1/(1-nu_12*nu_21), 0; ...
           nu_21*E_1/(1-nu_12*nu_21), E_2/(1-nu_12*nu_21), 0; ...
           0,                         0,                   2*G_12];

    % Rotate Q using T:
    Qxy_temp = T \ Q12 * T;

    % Adjust stray values of 2 to get final Q matrix:
    Qxy_temp(:,3) = Qxy_temp(:,3) * 0.5;
    Q = Qxy_temp;

end