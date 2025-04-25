function Q_combined = build_Q_comb(fiber_properties, matrix_properties, composite_properties, layup)
    % build_Q_comb - Constructs a combined Q matrix for all plies in a laminate
    %
    % Inputs:
    %   fiber_properties    - Vector containing fiber material properties [E_1f, E_2f, G_12f, nu_12f]
    %   matrix_properties   - Vector containing matrix material properties [E_m, nu_m]
    %   composite_properties- Vector containing composite properties [V_f, xi_1, xi_2]
    %   layup               - Vector of ply angles (in radians)
    %
    % Outputs:
    %   Q_combined          - 3x(3n) array containing the combined stiffness matrices for all plies
    %
    % Dependencies:
    %   calculate_Q_S_matrix

    % Number of lamina
    n = length(layup);

    % Initialize combined Q array
    Q_combined = zeros(3,3*n);

    % Loop through each lamina
    for i = 1:n
        % Append lamina-specific properties
        composite_properities = [composite_properties, layup(i)];

        % Compute Q matrix for the current lamina
        [Qi,~] = calculate_Q_S_matrix(fiber_properties,matrix_properties,composite_properities);

        % Store the Q matrix in the combined array
        Q_combined(:,(3*i-2):(3*i)) = Qi;
    end
end
