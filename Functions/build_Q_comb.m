function Q_combined = build_Q_comb(fiber_properties, matrix_properties, composite_properties, theta)
    % Function to build the combined Q array for all lamina
    %
    % Inputs:
    %   fiber_properties        E_1f, E_2f, G_12f, nu_12f
    %   matrix_properties       E_m, nu_m
    %   composite_properties    V_f, xi_1, xi_2
    %   theta                   Vector of ply angles [radians]
    %
    % Outputs:
    %   Q_combined - 3x3n matrix containing Q matrices for all plies concatenated
    %                horizontally where n is number of plies
    %
    % Method:
    %   1. Loop through each ply angle
    %   2. Calculate Q matrix for each ply using calculate_Q_S_matrix
    %   3. Combine Q matrices into single array
    %


    % Number of lamina
    n = length(theta);
    
    % Initialize combined Q array
    Q_combined = zeros(3,3*n);
    
    % Loop through each lamina
    for i = 1:n
        % Append lamina-specific properties
        composite_properities = [composite_properties, theta(i)];
        
        % Compute Q matrix for the current lamina
        [Qi,~] = calculate_Q_S_matrix(fiber_properties,matrix_properties,composite_properities);
        
        % Store the Q matrix in the combined array
        Q_combined(:,(3*i-2):(3*i)) = Qi;
    end
end