function T = build_T(theta)
    % build_T - Constructs the transformation matrix for a given ply angle
    %
    % Inputs:
    %   theta - Rotation angle in radians
    %
    % Outputs:
    %   T     - 3x3 transformation matrix
    %
    % Dependencies:
    %   None

    c = cos(theta);
    s = sin(theta);
    T = [ c^2, s^2,  2*c*s; ...
          s^2, c^2, -2*c*s; ...
         -c*s, c*s,  c^2-s^2];

end
