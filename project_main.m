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
% layup = [0 45 -45 90 0 60 -60 -60 60 0 90 -45 45 0];
layup = [90 60 -60 45 -45 0 0 0 0 0 0 -45 45 -60 60 90];
for i = 1:length(V_f)
    composite_properties = [V_f(i), xi_1, xi_2];
    t = t_from_Vf(V_f(i));
    [~,~,ABD_baseline] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, layup, t);
    Axx_vec(i) = ABD_baseline(1,1);
    Dxx_vec(i) = ABD_baseline(4,4);
    Dyy_vec(i) = ABD_baseline(5,5);
    ABD_cell{i} = ABD_baseline;
end

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





%% 1.2 Design for Strength

% Loads to survive:
N_xx = 600; % N/mm
N_thetatheta = 200; % N/mm applied in any possible direction theta
M_xx_t = 100; % N
M_xx_c = -100; % N


layup = [90 60 -60 45 -45 0 0 0 0 0 0 -45 45 -60 60 90];
composite_properties = [0.5 1 1];
t = 0.1;

load_xy = [N_xx; 0; 0; M_xx_t; 0; 0];

[~,~,ABD, Q_combined, t_vector] = laminate_stiffness(fiber_properties,matrix_properties,composite_properties, layup, t);
abd = get_abd(ABD);

e_xy = abd * load_xy;

lamina_strain = compute_lamina_strain(e_xy, t_vector);
lamina_stress_xy = compute_lamina_stress(Q_combined,lamina_strain);
lamina_stress_12 = rotate_stress(lamina_stress_xy, layup);
% [~,criteria] = check_tsaiwu_2d(lamina_stress_12, [F_1t; F_1c; F_2t; F_2c; F_6]);

%% 1.3 Design for Stiffness and Strength

% Use Stiffness and Load requirements from previous sections
