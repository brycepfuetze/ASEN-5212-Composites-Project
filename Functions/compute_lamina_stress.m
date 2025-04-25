function lamina_stress = compute_lamina_stress(Q_combined,strain,t_vector)
% Inputs
%   Q_combined      - 3x3n array containing n 3x3 Q matrices for n laminas
%   Option 1:
%       strain = lamina_strain   - 3xn matrix where the ith column is
%                                   [e_x;e_y;gamma] corresponding to the
%                                   ith lamina, i = 1:n
%   Option 2:
%       strain = laminate_strain - 6x1 vector: [e^0 ; kappa]
%       t_vector                 - 1xn or nx1 vector containing thicknesses
%                                  of lamina; measured in mm
%
% Outputs
%   lamina_stress   - 3xn matrix where the ith column is
%                     [sigma_x;sigma_y;tau_s] corresponding to the ith
%                     lamina, i = 1:n
%
% Dependencies
%   compute_lamina_strain (optional)

    % Check for inputs Option 1 or Option 2
    if nargin == 2
        lamina_strain = strain;
        sz = size(lamina_strain);
        n = sz(2);
        if sz(1) ~= 3
            error("Incorrectly sized lamina_strain input")
        end
    elseif nargin == 3
        laminate_strain = strain;
        laminate_strain = laminate_strain(:);
        if length(laminate_strain) ~= 6
            error("Laminate strain vector is the wrong length")
        end
        n = length(t_vector);
        lamina_strain = compute_lamina_strain(laminate_strain,t_vector);
    end

    Q_sz = size(Q_combined);
    if Q_sz/3 ~= n
        error("Mismatch between n of Q_combined and n of other inputs")
    end

    % preallocate:
    lamina_stress = NaN(3,n);

    % loop through lamina and compute stress:
    for i = 1:n
        lamina_stress(:,i) = Q_combined(:,(3*i-2):(3*i)) * lamina_strain(:,i);
    end
end

