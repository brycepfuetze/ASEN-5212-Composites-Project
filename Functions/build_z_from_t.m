function [z_vec, h] = build_z_from_t(t_vector)
% Inputs
%   t_vector - 1xn or nx1 vector containing thicknesses of lamina; measured
%              in mm
%
% Outputs
%   z_vec    - A (n+1)x1 vector containing the z coordinate of each lamina
%              boundary relative to z = 0 at h/2
%   h        - the total thickness of the laminate


    n = length(t_vector); % number of laminas
    h = sum(t_vector); % laminate thickness
    z_vec = zeros(n+1,1); % prealocate
    z_vec(1) = -h/2; % bottom value
    z_vec(end) = h/2; % top value
    % Fill in z vector
    for i = 2:n
        z_vec(i) = z_vec(i-1) + t_vector(i);
    end

end
