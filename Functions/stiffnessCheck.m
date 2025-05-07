function [] = stiffnessCheck(ABD)

    if ABD(1,1) >= 100000; disp("Pass A_xx Criteria");
    else; disp("Fail A_xx Criteria");
    end


    Ntest = 1000;
    theta = deg2rad(linspace(0,90,Ntest));

    Ayypass = 1;
    for i = 1:Ntest
        T = build_T(theta(i));
        bigT = [T, zeros(3,3); zeros(3,3), T'];
        ABDrotate = inv(bigT) * ABD * inv(bigT');
        
        if ABDrotate(1,1) <= 30000
            Ayypass = 0;
        end
    end
    
    if Ayypass == true; disp("Pass A_xx Bar Criteria")
    else; disp("Fail A_xx Bar Criteria")
    end

    if ABD(4,4) >= 25000; disp("Pass D_xx Criteria");
    else; disp("Fail D_xx Criteria");
    end

    if ABD(5,5) >= 15000; disp("Pass D_yy Criteria");
    else; disp("Fail D_yy Criteria");
    end

end