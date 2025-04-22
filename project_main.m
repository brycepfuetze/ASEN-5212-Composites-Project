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
E_1f = 270; % GPa
E_2f = 14; % GPa
G_12f = 10; % GPa
nu_12f = 0.22; % GPa
rho_f = 1750; % kg/m^3

% Epoxy Matrix
E_m = 3.5; % GPa
nu_m = 0.37;
rho_m = 1200; % kg/m^3

% Composite Properties
V_f = .4:0.01:.65;
eta_1 = 1;
eta_2 = 1;
t_0 = 0.1; % mm

% Failure properties
ult_strain_f = 0.01;
F_mt = 0.120; % GPa
F_mc = 0.150; % GPa
F_ms = 0.080; % GPa

%% 1.1 Design for Stiffness

% Stiffness Criteria:
A_xx_min = 100000; % N/mm
A_xx_overall_min = 30000; % N/mm
D_xx_min = 25000; % Nmm
D_yy_min = 15000; % Nmm


%% 1.2 Design for Strength

% Loads to survive:
N_xx = 600; % N/mm
N_thetatheta = 200; % N/mm applied in any possible direction theta
M_xx_t = 100; % N
M_xx_c = -100; % N

%% 1.3 Design for Stiffness and Strength

% Use Stiffness and Load requirements from previous sections
