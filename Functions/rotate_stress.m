function stress_12 = rotate_stress(stress_xy, theta_vec)
% Inputs
%   stress_xy    - 3xn matrix containing lamina stress or strain vectors in
%                  the xy plane
%   theta_vec    - vector of n orientation angles of laminas, in radians
%
% Outputs
%   stress_12    - 3xn matrix containing lamina stress vectors in
%                  their local 12 frames
%
% IMPORTANT NOTE:
%   Be more careful with strain the stress, there are pesky "2" coefficients on shear sometimes but not other times.
%
% Dependencies
%   build_T

    % Check inputs
    sz = size(stress_xy);
    n = sz(2);
    if sz(1) ~= 3
        error("Incorrectly sized stress_xy input")
    end

    if length(theta_vec) ~= n
        error("Mismatched number of lamina vectors and lamina rotation angles")
    end

    % Preallocate
    stress_12 = NaN(3,n);

    % loop through laminas and rotate:
    for i = 1:n
        T = build_T(theta_vec(i));
        stress_12(:,i) = T * stress_xy(:,i);
    end

end
