function lamina_strain = compute_lamina_strain(laminate_strain,t_vector)
% Inputs:
%   laminate_strain - 6x1 vector: [e^0 ; kappa]
%   t_vector        - 1xn or nx1 vector containing thicknesses of lamina; measured
%                     in mm
%
% Outputs:
%   lamina_strain   - 3xn matrix where the ith column is [e_x;e_y;gamma]
%                     corresponding to the ith lamina, i = 1:n
%
% Dependencies:
%   build_z_from_t

    % enforce laminate_strain is a column:
    laminate_strain = laminate_strain(:);

    % check for length:
    if length(laminate_strain) ~= 6
        error("Laminate strain vector is the wrong length")
    end

    % compute number of lamina:
    n = length(t_vector);

    % preallocate:
    lamina_strain = NaN(3,n);

    % compute z vector based on lamina thicknesses
    z_vec = build_z_from_t(t_vector);

    % compute lamina thicknesses
    for i = 1:n
        z = mean(z_vec(i:i+1)); % just splitting the difference here
        lamina_strain(:,i) = laminate_strain(1:3) + z * laminate_strain(4:6);
    end
end

