function [Ex, Ey, ABD, Q_combined, t_vector] = laminate_stiffness(fiber_properties, matrix_properties, composite_properties, layup, t)
    % laminate_stiffness - Computes laminate stiffness properties and matrices
    %
    % Inputs:
    %   fiber_properties    - Vector containing fiber material properties [E_1f, E_2f, G_12f, nu_12f]
    %   matrix_properties   - Vector containing matrix material properties [E_m, nu_m]
    %   composite_properties- Vector containing composite properties [V_f, xi_1, xi_2]
    %   layup               - Vector of ply angles (in radians)
    %   t                   - Thickness of each lamina
    %
    % Outputs:
    %   Ex                  - Average laminate stiffness in the x-direction
    %   Ey                  - Average laminate stiffness in the y-direction
    %   ABD                 - 6x6 ABD stiffness matrix
    %   Q_combined          - 3x(3n) array containing the combined stiffness matrices for all plies
    %   t_vector            - Vector of thicknesses for each lamina
    %
    % Dependencies:
    %   build_Q_comb
    %   calculate_ABD_matrix
    %   av_lam_stif

    % Compute number of lamina
    n = length(layup);

    % build t_vector
    t_vector = ones(n,1) * t;

    % compute laminate thickness
    h = sum(t_vector);

    % Build Q_combined matrix
    Q_combined = build_Q_comb(fiber_properties,matrix_properties,composite_properties,layup);

    % Compute laminate stiffness matrix
    ABD = calculate_ABD_matrix(Q_combined,t_vector);

    % Compute mean lamina stiffnesses
    [Ex, Ey] = av_lam_stif(ABD,h);

end
