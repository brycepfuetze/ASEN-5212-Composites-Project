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


%% Helper Functions

function t = t_from_Vf(V_f)
    % Inputs:
    %       V_f     volume fraction, between 0 and 1. Fraction of volume made up of fibers.
    % Outputs:
    %       t       thickness of a lamina with volume fraction V_f. [mm]
    %
    % Method:
    %       Assumes the real quantity of fiber in the lamina is constant: 0.05 mm of thickness must be made up of fibers.
    %           -> this implies that lamina thickness is equal to the fiber thickness divided by V_f.

    if V_f < 0
        error("Non-physical volume fraction number (V_f < 0)")
    end
    
    if V_f > 1
        error("Non-physical volume fraction number (V_f > 1)")
    end

    t_f = 0.05; % thickness of carbon fibers, a constant value for this project

    t = t_f / V_f; % lamina thickness

    % just double check:
    if V_f > 0.5 % there is less matrix, t < t_0
        check = t < 0.1;
        if ~check
            error("Unexpected thickness calculation")
        end
    elseif V_f < 0.5 % there is more matrix, t > t_0
        check = t > 0.1;
        if ~check
            error("Unexpected thickness calculation")
        end
    else % V_f must be 0.5, no change
        check = t == 0.1;
        if ~check
            error("Unexpected thickness calculation")
        end
    end

end
