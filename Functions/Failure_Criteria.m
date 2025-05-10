%% failure criteria for lamina
function [F1t, F1c, F2t, F2c, F6] = Failure_Criteria(Vf)
% Failure_Criteria.m
%
% Computes the strength criteria for a composite lamina based on the volume fraction.
%
% Inputs:
%   Vf      Volume fraction of fiber in the composite
%
% Outputs:
%   F1t     Longitudinal tensile strength [MPa]
%   F1c     Longitudinal compressive strength [MPa]
%   F2t     Transverse tensile strength [MPa]
%   F2c     Transverse compressive strength [MPa]
%   F6      Shear strength [MPa]
%
% Dependencies:
%   None (uses only internal calculations)
%
% Notes:
%   Uses rule-of-mixtures and micromechanics-based estimates for lamina strengths.
%   All strengths are returned in MPa.
%

    % Fiber properties
    E1f = 270e3; % MPa
    E2f = 14e3;  % MPa
    G12f = 10e3; % MPa

    % Matrix properties
    Em = 3.5e3;  % MPa
    nu_m = 0.37;
    Gm  = Em / (2 * (1 + nu_m));

    % Matrix failure strengths
    Fmt = 120;   % Matrix tensile strength [MPa]
    Fmc = 150;   % Matrix compressive strength [MPa]
    Fms = 80;    % Matrix shear strength [MPa]

    % Ultimate fiber strain (tension)
    eps_f = 0.01;

    % Compute lamina failure criteria
    F1t = eps_f * E1f * (Vf + (1 - Vf) * (Em / E1f)); % Longitudinal tensile
    F1c = 2 * Vf * sqrt((Em * E1f * Vf) / (3 * (1 - Vf))); % Longitudinal compressive

    % Transverse and shear strengths using micromechanics factors
    k2 = (1 - Vf * (1 - (Em / E2f))) / (1 - (1 - (Em / E2f) * sqrt(4 * Vf / pi)));
    F2t = Fmt / k2; % Transverse tensile
    F2c = Fmc / k2; % Transverse compressive

    ktau = (1 - Vf * (1 - (Gm / G12f))) / (1 - (1 - (Gm / G12f) * sqrt(4 * Vf / pi)));
    F6 = Fms / ktau; % Shear strength

end
