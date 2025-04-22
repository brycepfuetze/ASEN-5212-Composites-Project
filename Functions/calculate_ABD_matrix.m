function ABD = calculate_ABD_matrix(Q_combined,t_vector)
    % calculate_ABD_matrix.m 
    %
    % ASEN 5112
    % Final Project
    % 8 May 2025
    % 
    % Inputs:
    %       Q_combined  3x(3n) array of 3x3 Qk matrices. For n=3 laminas,
    %                   Q_combined would be 3x9
    %       t_vector    1xn or nx1 vector containing thicknesses of lamina,
    %                   in the same order as Q_combined
    %     
    % Outputs:
    %       ABD         6x6 ABD stiffness matrix
    % 
    % Method:
    %       - Build z matrix
    %       - Initilize A, B, D matrices
    %       - Fill in ij index of each one lamina at a time
    %       - Insert A, B, D matrices into full ABD output matrix
    %

    % Determine Thicknesses
    n = length(t_vector); % number of laminas
    h = sum(t_vector);
    z = zeros(n+1,1);
    z(1) = -h/2;
    z(end) = h/2;
    % Fill in z vector
    for i = 2:n
        z(i) = z(i-1) + t_vector(i);
    end
    
    % double check the inputs are all the correct lengths
    sz = size(Q_combined);
    if ~(sz(2)/3 == n)
        error("Mismatched number of Q matrices and thicknesses")
    end

    % Initialize sub-matrices
    A = zeros(3,3);
    B = zeros(3,3);
    D = zeros(3,3);

    % Loop through ij indicies
    for i = 1:3
        for j = 1:3
            % loop through n lamina
            for k = 1:n
                idx = 3*k - 3 + j; % index into long Q_combined
                % Incrementally add lamina values to ij indicies:
                A(i,j) = A(i,j) + Q_combined(i,idx) * (z(k+1) - z(k));
                B(i,j) = B(i,j) + (1/2) * Q_combined(i,idx) * (z(k+1)^2 - z(k)^2);
                D(i,j) = D(i,j) + (1/3) * Q_combined(i,idx) * (z(k+1)^3 - z(k)^3);
            end
        end
    end
    % Initialize output matrix
    ABD = zeros(6,6);

    % Input sub-matrices to output
    ABD(1:3,1:3) = A;
    ABD(4:6,4:6) = D;
    ABD(1:3,4:6) = B;
    ABD(4:6,1:3) = B;
end