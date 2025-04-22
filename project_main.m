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


