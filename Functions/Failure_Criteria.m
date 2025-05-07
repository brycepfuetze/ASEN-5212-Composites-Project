%% failure criteria for lamina
function [F1t,F1c,F2t,F2c,F6] = Failure_Criteria(Vf)

% define given parameters
% fiber properties
E1f = 270*1000; % MPa
E2f = 14*1000; % MPa
G12f = 10*1000; % MPa
% epoxy properties
Em = 3.5*1000; % MPa
% failure properties
eps_f = 0.01; % ultimate strain of fibers in tension
Fmt = 120; % failure strength of matrix in tension, MPa
Fmc = 150; % failure strength of matrix in compression, MPa
Fms = 80; % failure strength of matrix in shear, MPa

% compute lamina failure criteria
F1t = eps_f*E1f*(Vf+(1-Vf)*(Em/E1f));
F1c = 2*Vf*sqrt((Em*E1f*Vf)/(3*(1-Vf)));
k2 = (1-Vf*(1-(Em/E2f)))/(1-(1-(Em/E2f)*sqrt(4*Vf/pi)));
F2t = Fmt/k2;
F2c = Fmc/k2;
ktau = (1-Vf*(1-(Gm/G12f)))/(1-(1-(Gm/G12f)*sqrt(4*Vf/pi)));
F6 = Fms/ktau;