% Function to compute mean lamina stiffnesses
function [Ebar_x, Ebar_y] = av_lam_stif(ABD,h)
    % av_lam_stif - Calculates average laminate stiffnesses
    %
    % Inputs:
    %   ABD - 6x6 laminate stiffness matrix
    %   h   - Total laminate thickness
    %
    % Outputs:
    %   Ebar_x - Average laminate stiffness in x-direction
    %   Ebar_y - Average laminate stiffness in y-direction
    %
    % Dependencies:
    %   get_abd.m

    abd = get_abd(ABD); % compute abd matrix
    a = abd(1:3,1:3); % extract a matrix

    % Compute mean stiffnesses
    Ebar_x = 1 / (h * a(1,1));
    Ebar_y = 1 / (h * a(2,2));
end
