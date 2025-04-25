function t = t_from_Vf(V_f)
    % Inputs:
    %       V_f     volume fraction, between 0 and 1. Fraction of volume made up of fibers.
    % Outputs:
    %       t       thickness of a lamina with volume fraction V_f. [mm]
    %
    % Method:
    %       Assumes the real quantity of fiber in the lamina is constant: 0.05 mm of thickness must be made up of fibers.
    %           -> this implies that lamina thickness is equal to the fiber thickness divided by V_f.

    % Check Inputs
    if V_f < 0
        error("Non-physical volume fraction number (V_f < 0)")
    end

    if V_f > 1
        error("Non-physical volume fraction number (V_f > 1)")
    end

    t_f = 0.05; % thickness of carbon fibers, a constant value for this project

    t = t_f / V_f; % lamina thickness

    % just double check:
    if V_f > 0.5 % there is less matrix, t < t_0
        check = t < 0.1;
        if ~check
            error("Unexpected thickness calculation")
        end
    elseif V_f < 0.5 % there is more matrix, t > t_0
        check = t > 0.1;
        if ~check
            error("Unexpected thickness calculation")
        end
    else % V_f must be 0.5, no change
        check = t == 0.1;
        if ~check
            error("Unexpected thickness calculation")
        end
    end

end
