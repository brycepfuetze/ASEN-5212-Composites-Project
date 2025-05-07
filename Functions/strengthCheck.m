function pass = strengthCheck(layup, V_f)

    % Carbon Fibers
    E_1f = 270e3; % MPa
    E_2f = 14e3; % MPa
    G_12f = 10e3; % MPa
    nu_12f = 0.22; % 
    
    % Epoxy Matrix
    E_m = 3.5e3; % MPa
    nu_m = 0.37;
    
    % Form input vectors
    fiber_properties = [E_1f, E_2f, G_12f, nu_12f];
    matrix_properties = [E_m, nu_m];
    
    composite_properties = [V_f, 1, 1];
    t = t_from_Vf(V_f);
    
    % Loads to survive:
    N_xx = 600; % N/mm
    N_thetatheta = 200; % N/mm applied in any possible direction theta
    M_xx_t = 100; % N
    M_xx_c = -100; % N
    
    [F_1t, F_1c, F_2t, F_2c, F_6] = Failure_Criteria(V_f);

    theta = deg2rad(0:90);
    num_passed = 0;
    for i = 1:length(theta) % iterate through possible load directions
        nth = [cos(theta(i)); sin(theta(i)); 0; 0; 0; 0] * N_thetatheta;
    
        % Check tension
        
        load_xy = [N_xx; 0; 0; M_xx_t; 0; 0] + nth;
        
        [~,~,ABD, Q_combined, t_vector] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, layup, t);
        abd = get_abd(ABD);
        
        e_xy = abd * load_xy;
        
        lamina_strain = compute_lamina_strain(e_xy, t_vector);
        lamina_stress_xy = compute_lamina_stress(Q_combined,lamina_strain);
        lamina_stress_12 = rotate_stress(lamina_stress_xy, layup);
        [fail_ten, criteria_ten] = check_tsaiwu_2d(lamina_stress_12, [F_1t; F_1c; F_2t; F_2c; F_6]);
        
        % Check compression
        
        load_xy = [N_xx; 0; 0; M_xx_c; 0; 0];
        
        [~,~,ABD, Q_combined, t_vector] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, layup, t);
        abd = get_abd(ABD);
        
        e_xy = abd * load_xy;
        
        lamina_strain = compute_lamina_strain(e_xy, t_vector);
        lamina_stress_xy = compute_lamina_stress(Q_combined,lamina_strain);
        lamina_stress_12 = rotate_stress(lamina_stress_xy, layup);
        [fail_comp, criteria_comp] = check_tsaiwu_2d(lamina_stress_12, [F_1t; F_1c; F_2t; F_2c; F_6]);
    
        fail = fail_ten | fail_comp;
        criteria = max(criteria_ten,criteria_comp)
    
        if any(fail)
            break;
        else
            num_passed = num_passed + 1;
        end
    end
    
    if num_passed == length(theta) % this implies they all passed yay!
        pass = true;
        fprintf("Laminate with V_f %.2f and %.0f layers Passes\n",V_f,length(layup));
    else
        pass = false;
        fprintf("Laminate with V_f %.2f and %.0f layers Fails with max criteria: %.4f\n",V_f, length(layup), max(criteria(criteria >= 1)));
    end

    figure
    b = bar(criteria);
    yline(1,"--k")
    % Get current axes
    ax = gca;

    % Loop through each bar and set the color based on criteria
    for k = 1:length(criteria)
        if criteria(k) > 1
            b.FaceColor = 'flat';
            b.CData(k, :) = [1 0 0]; % Red color for criteria > 1
        else
            b.FaceColor = 'flat';
            b.CData(k, :) = [0 1 0]; % Green color for criteria <= 1
        end
    end

end



    