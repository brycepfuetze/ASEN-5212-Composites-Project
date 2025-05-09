function [passVec] = stiffnessCheck(ABD)
% Take in an ABD and check if it passes the criteria for Project Part 1.1

    Axxpass = 0;
    Axxbarpass = 0;
    Dxxpass = 0;
    Dyypass = 0;


    if ABD(1,1) >= 100000
        % disp("Pass A_xx Criteria")
        Axxpass = 1;
    else
        % disp("Fail A_xx Criteria");
    end


    Ntest = 50;
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
    
    if Ayypass == true
        % disp("Pass A_xx Bar Criteria")
        Axxbarpass = 1;
    else
        % disp("Fail A_xx Bar Criteria")
    end

    if ABD(4,4) >= 25000
        % disp("Pass D_xx Criteria")
        Dxxpass = 1;
    else
        % disp("Fail D_xx Criteria");
    end

    if ABD(5,5) >= 15000
        % disp("Pass D_yy Criteria")
        Dyypass = 1;
    else
        % disp("Fail D_yy Criteria");
    end

    passVec = [Axxpass;Axxbarpass;Dxxpass;Dyypass];
end