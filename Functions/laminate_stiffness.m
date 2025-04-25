function [Ex, Ey, ABD] = laminate_stiffness(fiber_properties, matrix_properties, composite_properties, layup, t)

    n = length(layup);
    t_vector = ones(n,1) * t;
    h = sum(t_vector);
    
    Q_combined = build_Q_comb(fiber_properties,matrix_properties,composite_properties,layup);
    
    ABD = calculate_ABD_matrix_SHH(Q_combined,t_vector);
    
    % Compute mean lamina stiffnesses
    [Ex, Ey] = av_lam_stif(ABD,h);

end