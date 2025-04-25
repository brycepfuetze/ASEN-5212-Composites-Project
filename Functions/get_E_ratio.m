function [E_ratio] = get_E_ratio(Ex, Ey)
    % get_E_ratio - Computes the ratio of the larger modulus to the smaller modulus
    %
    % Inputs:
    %   Ex - Modulus in the x-direction
    %   Ey - Modulus in the y-direction
    %
    % Outputs:
    %   E_ratio - Ratio of the larger modulus to the smaller modulus
    %
    % Dependencies:
    %   None

    if Ex > Ey
        E_ratio = Ex/Ey;
    else
        E_ratio = Ey/Ex;
    end

end
