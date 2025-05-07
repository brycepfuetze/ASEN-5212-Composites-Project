function mass = get_mass(V_f, rho_f, rho_m, thickness)
% get_mass.m
%
% Returns the areal mass of a composite structure in [kg/m^2]
%
% Inputs:
%   V_f         The volume fraction of fiber in matrix
%   rho_f       The density of the fibers in [kg/m^3]
%   rho_m       The density of the matrix in [kg/m^3]
%   thickness   Either:
%                   A 1xn or nx1 vector containing the thicknesses of individual laminas
%               Or:
%                   a 1x1 vector containing h, the overall thickness of the laminate
%
% Outputs:
%   mass        The areal mass of the composite laminate in [kg/m^2]
%

    if length(thickness) ~= 1 % implies a vector of lamina thicknesses
        thickness = thickness(:);
        h = sum(thickness);
    else
        h = thickness;
    end

    rho = V_f * rho_f + (1 - V_f) * rho_m;

    mass = rho * h;

end