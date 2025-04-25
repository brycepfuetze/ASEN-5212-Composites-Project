% Function to compute mean lamina stiffnesses
function [Ebar_x, Ebar_y] = av_lam_stif(ABD,h)
    
    abd = get_abd(ABD);
    a = abd(1:3,1:3);

    % Compute mean stiffnesses
    Ebar_x = 1 / (h * a(1,1));
    Ebar_y = 1 / (h * a(2,2));
end