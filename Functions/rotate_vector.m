function vector_12 = rotate_vector(vector_xy, theta_vec)
% Inputs
%   vector_xy    - 3xn matrix containing lamina stress or strain vectors in
%                  the xy plane
%   theta_vec    - vector of n orientation angles of laminas, in radians
%
% Outputs
%   vector_12    - 3xn matrix containing lamina stress or strain vectors in
%                  their local 12 frames
%
% Dependencies
%   build_T

    % Check inputs
    sz = size(vector_xy);
    n = sz(2);
    if sz(1) ~= 3
        error("Incorrectly sized vector_xy input")
    end

    if length(theta_vec) ~= n
        error("Mismatched number of lamina vectors and lamina rotation angles")
    end

    % Preallocate
    vector_12 = NaN(3,n);

    % loop through laminas and rotate:
    for i = 1:n
        T = build_T(theta_vec(i));
        vector_12(:,i) = T * vector_xy(:,i);
    end

end
