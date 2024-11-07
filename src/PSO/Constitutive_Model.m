function [problem] = Constitutive_Model(problem, params)

% This function calculates the storage and loss modules of the constitutive
% model. It is compatiable with FMG-FMG, FMM-FMG, FMG-FMM, and FMM-FMM
% models, in which branches are configured in parallel.

% x := shifted frequency \omega * a_T

% Storage module for one general FMM-FMM Brnach:
% E'(x) = Ec1 * 
% ( (x * tauc1)^alpha1 * cos(pi * alpha1 / 2) + ...
% (x * tauc1)^(2 * alpha1 - beta1) * cos(pi * beta1 / 2) ) / ...
% ( 1 + (x * tauc1)^(alpha1 - beta1) * cos(pi * (alpha1 - beta1) / 2) + ...
% (x * tauc1)^(2 * (alpha1 - beta1)) )

% Loss module for one general FMM-FMM Brnach:
% E''(x) = Ec1 * 
% ( (x * tauc1)^alpha1 * sin(pi * alpha1 / 2) + ...
% (x * tauc1)^(2 * alpha1 - beta1) * sin(pi * beta1 / 2) ) / ...
% ( 1 + (x * tauc1)^(alpha1 - beta1) * cos(pi * (alpha1 - beta1) / 2) + ...
% (x * tauc1)^(2 * (alpha1 - beta1)) )

Ec1    = params(1);
tauc1  = params(2);
alpha1 = params(3);
beta1  = params(4);
Ec2    = params(5);
tauc2  = tauc1 * sqrt(Ec1/Ec2);
alpha2 = params(6);
beta2  = params(7);

ca1 = cos(0.5*pi*alpha1);
cb1 = cos(0.5*pi*beta1);
sa1 = sin(0.5*pi*alpha1);
sb1 = sin(0.5*pi*beta1);
cab1 = cos(0.5*pi*(alpha1-beta1));

ca2 = cos(0.5*pi*alpha2);
cb2 = cos(0.5*pi*beta2);
sa2 = sin(0.5*pi*alpha2);
sb2 = sin(0.5*pi*beta2);
cab2 = cos(0.5*pi*(alpha2-beta2));

tauc1w = tauc1*problem.modelData(1,:);
tauc2w = tauc2*problem.modelData(1,:);

num1_Ep = Ec1*(tauc1w.^alpha1*ca1 + tauc1w.^(2*alpha1-beta1)*cb1);
num2_Ep = Ec2*(tauc2w.^alpha2*ca2 + tauc2w.^(2*alpha2-beta2)*cb2);

num1_Epp = Ec1*(tauc1w.^alpha1*sa1 + tauc1w.^(2*alpha1-beta1)*sb1);
num2_Epp = Ec2*(tauc2w.^alpha2*sa2 + tauc2w.^(2*alpha2-beta2)*sb2);

den1 = 1 + tauc1w.^(alpha1-beta1)*cab1 + tauc1w.^(2*(alpha1-beta1));
den2 = 1 + tauc2w.^(alpha2-beta2)*cab2 + tauc2w.^(2*(alpha2-beta2));

problem.modelData(2, :) = num1_Ep./den1 + num2_Ep./den2;
problem.modelData(3, :) = num1_Epp./den1 + num2_Epp./den2;

end