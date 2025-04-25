function T = build_T(theta)

    c = cos(theta);
    s = sin(theta);
    T = [ c^2, s^2,  2*c*s; ...
          s^2, c^2, -2*c*s; ...
         -c*s, c*s,  c^2-s^2];

end