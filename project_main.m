% ASEN 5212 Composite Structures and Materials
% Final Project
%
% Main Script
%
% Claire Kent, Bryce Pfuetze, Samuel Hatton
%
% 8 May 2025

%% Housekeeping
clear; clc; close all;

% make plots pretty
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',20);
set(groot,'defaultLineLineWidth',1.5);
set(groot,'defaultAxesBox','on')
set(groot,'defaultTextFontSize',16)

addpath("Functions/")



%% Material Property Definition

% Carbon Fibers
E_1f = 270e3; % MPa
E_2f = 14e3; % MPa
G_12f = 10e3; % MPa
nu_12f = 0.22; %
rho_f = 1750; % kg/m^3

% Epoxy Matrix
E_m = 3.5e3; % MPa
nu_m = 0.37;
rho_m = 1200; % kg/m^3

% Composite Properties
V_f = .4:0.01:.65;
eta_1 = 1;
eta_2 = 1;
t_0 = 0.1; % mm

% Form input vectors
fiber_properties = [E_1f, E_2f, G_12f, nu_12f];
matrix_properties = [E_m, nu_m];
xi_1 = 1;
xi_2 = 1;
% composite_properties = [V_f, xi_1, xi_2];

% Failure properties
ult_strain_f = 0.01;
F_mt = 0.120e3; % MPa
F_mc = 0.150e3; % MPa
F_ms = 0.080e3; % MPa


%% Define Candidate Layups

layup_1 = @(phi) [0 pi/4 -pi/4 pi/2 pi/2 -pi/4 pi/4 0] + phi; % [0 45 -45 90]_s
layup_2 = @(phi) deg2rad([0 60 -60 -60 60 0]) + phi; % [0/60/-60]_s

% %%% vary V_f to pick an optimal one:
% mass_vec = get_mass(V_f, rho_f, rho_m, t_from_Vf(V_f));
%
% figure
% plot(V_f, mass_vec)
% xlabel("$$V_f$$")
% ylabel("Areal Mass $$[kg/m^2]$$")

m = @(n, vf) 0.05 * n * rho_f + ((1./vf) - 1) * 0.05 * n * rho_m;

m1 = m(1:25, 0.5);
figure
plot(1:25,m1)
xlabel("$$n$$")
ylabel("Areal Mass $$[kg/m^2]$$")

dmdn = mean(diff(m1));

m2 = m(1,V_f);
figure
plot(V_f,m2)
xlabel("$$V_f$$")
ylabel("Areal Mass $$[kg/m^2]$$")

dmdvf = mean(diff(m2));

%% 1.1 Design for Stiffness

% Stiffness Criteria:
A_xx_min = 100000; % N/mm
A_xx_overall_min = 30000; % N/mm
D_xx_min = 25000; % Nmm
D_yy_min = 15000; % Nmm

%%% Quasi-isotropic baseline

ABD_cell = cell(1,length(V_f));
Axx_vec = zeros(length(V_f),1);
Dxx_vec = zeros(length(V_f),1);
Dyy_vec = zeros(length(V_f),1);

% layup = [0 90 0 90 90 60 -60 -60 60 90 90 0 90 0];
% layup = [0 90 0 90 0 0 0 0 0 0 90 0 90 0];
%layup = [90 60 -60 45 -45 0 0 0 0 0 0 -45 45 -60 60 90];
% layup = [55 0 90 60 -45  0 -60 60 0  45 -60 90 0 -50];
% layup = [0 0 0 0 0 0 0 0];
layup = [0 5 -65 15 45 0 0 45 15 -65 5 0];
for i = 1:length(V_f)
    composite_properties = [V_f(i), xi_1, xi_2];
    t = t_from_Vf(V_f(i));
    [~,~,ABD_baseline] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, deg2rad(layup), t);
    % stiffnessCheck(ABD_baseline)
    Axx_vec(i) = ABD_baseline(1,1);
    Dxx_vec(i) = ABD_baseline(4,4);
    Dyy_vec(i) = ABD_baseline(5,5);
    ABD_cell{i} = ABD_baseline;
end

ABD = ABD_cell{1};
stiffnessCheck(ABD)

figure
plot(V_f,Axx_vec)
xlabel("$$V_f$$")
ylabel("$$A_{xx}$$")
yline(A_xx_min,'k--')

figure
plot(V_f,Dxx_vec)
xlabel("$$V_f$$")
ylabel("$$D_{xx}$$")
yline(D_xx_min,'k--')

figure
plot(V_f,Dyy_vec)
xlabel("$$V_f$$")
ylabel("$$D_{yy}$$")
yline(D_yy_min,'k--')

%% Brute force



V_f = 0.4;
t = t_from_Vf(V_f);
composite_properties = [V_f, xi_1, xi_2];

% parfor a = 1:leng
%     for b = 1:leng
%         for c = 1:leng
%             for d = 1:leng
%                 for e = 1:leng
%                     %for f = 1:leng
%                         %for g = 1:leng
%                         layup = deg2rad([thetas(a), thetas(b),thetas(c),thetas(d), thetas(e) 0, 0, 0, thetas(e), thetas(d), thetas(c), thetas(b), thetas(a)]);
%                         [~,~,ABD] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, layup, t);
%                         [Pass] = stiffnessCheck(ABD);
%
%                         if sum(Pass) == 4
%                             layup = rad2deg(layup)
%                             disp("Working Laminate Found")
%                             disp(sum(Pass))
%                             disp(layup)
%
%                         end
%                        % end
%                     %end
%                 end
%             end
%         end
%     end
%     disp(a)
% end

% % clc
% tic;
% % Define the thetas to be searched:
% dt = 15;
% thetas = (-90 + dt):dt:90; % Now this has 12 elements
% 
% % Define the target number of laminas:
% n = 12;
% n_fill = 4; % number of zero laminas to pad the middle
% 
% % Generate mid layers vector
% mid_layers = zeros(1, n_fill);
% 
% % Get all possible angle combinations:
% [angle_combinations, num_combinations] = build_angle_combos(thetas, n, n_fill);
% 
% count = 0;
% parfor i = 1:num_combinations
%     layup_angles = angle_combinations(i, :);
% 
%     % Construct the layup with varying and fixed angles
%     layup = deg2rad([layup_angles, mid_layers, layup_angles(end:-1:1)]);
% 
%     [~,~,ABD] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, layup, t);
%     [Pass] = stiffnessCheck(ABD);
% 
%     if sum(Pass) == 4
%         count = count + 1;
%         % layup_degrees = rad2deg(layup);
%         % disp("Working Laminate Found");
%         % disp(layup_degrees);
%     end
% end
% 
% elapsedTime = toc;
% fprintf("Found %.0f / %.0f %.0f-lamina layups pass in %.2f seconds.\n",count, num_combinations,n,elapsedTime)

% [count, winners] = parStiffnessCheck(15, 13, 5, 0.4);

%%

% dt_vec = [15 10 5 2.5 1];
% 
% for i = 1:length(dt_vec)
%     count = parStiffnessCheck(dt_vec(i), 12, 4, 0.4);
%     if count > 0
%         fprintf("%.0f passing layups found with dt = %.1f\n",count,dt_vec(i));
%         break
%     end
% end



%% 1.2 Design for Strength

% Loads to survive:
N_xx = 600; % N/mm
N_thetatheta = 200; % N/mm applied in any possible direction theta
M_xx_t = 100; % N
M_xx_c = -100; % N


Vf = 0.65;
% layup = [90 60 -60 45 -45 0 0 0 0 0 0 -45 45 -60 60 90];
layup = [0 60 -60 -60 60 0];

pass = strengthCheck(deg2rad(layup),Vf,true);

%% Brute Force check lamina sizes for strength

%%% For lamina less than 16, we can afford to run standard MATLAB Code

% % Initialize detail savers:
% count_vec = zeros(11,1);
% winners_array = cell(11,1);
% 
% % Loop through 5-10 lamina, holding 0 or 1 middle lamina constant
% for i = 5:10
%     n = i;
%     if rem(n,2) == 0
%         n_fill = 0;
%     else
%         n_fill = 1;
%     end
%     [count_vec(i-4), winners_array{i-4}] = parStrengthCheck(15, n, n_fill, 0.65);
%     fprintf("Completed n = %.0f\n", n)
% end
% 
% % We need to hold more constant to make compute times half reasonable:
% % Loop through 11-15 lamina, holding 4 or 5 middle lamina constant:
% for i = 11:15
%     n = i;
%     if rem(n,2) == 0
%         n_fill = 4;
%     else
%         n_fill = 5;
%     end
%     [count_vec(i-4), winners_array{i-4}] = parStrengthCheck(15, n, n_fill, 0.65);
%     fprintf("Completed n = %.0f\n", n)
% end

%%%%%% Need More Options %%%%%%
% It seems like blocking the center out as zeros is disadvantageous, 90s
% are maybe better. Let's brute force without restricting the middle
% laminas using compiled C code to run faster:

% parStrengthCheck_3_mex(1,6,0,0.65);
% parStrengthCheck_3_mex(5,7,1,0.65);
% parStrengthCheck_4_mex(5,8,0,0.65);
% parStrengthCheck_4_mex(15,9,1,0.65);
% parStrengthCheck_5_mex(15,10,0,0.65);
% parStrengthCheck_5_mex(30,11,1,0.65); % < 2 minutes
% parStrengthCheck_6_mex(15,12,0,0.65); % 2 minutes
% parStrengthCheck_6_mex(15,13,1,0.65); % 3ish minutes
% parStrengthCheck_7_mex(15,14,0,0.65); % 2188 sec = 36.5 minutes
% parStrengthCheck_7_mex(15,15,1,0.65); % 2325 sec = 38:45 minutes
    % Can't compute 10 deg increments, int overflow problems
% parStrengthCheck_8_mex(30,16,0,0.65);

% 30 and 45 deg return the same solutions for 16 layers!

[count_c, winners_c, time_c] = parStrengthCheck_8_mex(45, 16, 0, 0.65);
% [count, winners, time] = parStrengthCheck(45, 16, 0, 0.65);

% Want lightest option! => decrease volume fraction to narrow it down.
pass_vec = zeros(1,3);
for i = 1:3
    pass_vec(i) = strengthCheck(deg2rad(winners_c(i,:)), 0.49, true);
end

strength_pick.n = 16;
strength_pick.layup = winners_c(1,:);
strength_pick.Vf = 0.49;
strength_pick.tvec = t_from_Vf(strength_pick.Vf, strength_pick.n);
strength_pick.m = get_mass(strength_pick.Vf,rho_f,rho_m,strength_pick.tvec);


%% 1.3 Design for Stiffness and Strength

% Use Stiffness and Load requirements from previous sections

% Our stiffness lamina doesn't work, I assume, but let's check:

stiff_layup = [0 90 0 75 0 0 0 0 0 75 0 90 0];
stiff_combined_pass = strengthCheck(deg2rad(stiff_layup), 0.49, true);

% Nope!

% Check strength lamina for stiffness:


composite_properties = [strength_pick.Vf, 1, 1];
[~,~,strength_pick.ABD] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, deg2rad(strength_pick.layup), strength_pick.tvec(1));
strength_combined_pass = stiffnessCheck(strength_pick.ABD)

% only dyy fails!
% what if we add a 90 on the outside?

%%

% layup = strength_pick.layup;
layup = winners_c(1,:);
Vf = 0.65;
% layup([1, end]) = 90;

Vf = 0.4:0.01:0.65;
for i = 1:length(Vf)
    pass = checkBoth(layup, Vf(i)); % passes dyy but not tsai-hill
    disp(sum(pass));
end

%% Need to go to 17:

