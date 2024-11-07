%% Data Input
clc;
close all;
format long e

input_data = importdata('Range 1.dat'); % FMM1-FMG2 Model is being implemented

validrange = 'G112:I203';
sheet = '20HS';
Tdata = readmatrix("Summary for New Master Curves 7-22-23.xlsx",'Sheet',sheet,'Range',validrange);

% Experimental data spliting
w_freq = Tdata(:,1); Ep_data = Tdata(:,2); Epp_data = Tdata(:,3);

figure(1)
loglog(w_freq,Ep_data,'ob','LineWidth',2.5,'MarkerSize',10)
set(gca,'LineWidth',2.5,'FontSize',18)

figure(2)
loglog(w_freq,Epp_data,'ob','LineWidth',2.5,'MarkerSize',10)
set(gca,'LineWidth',2.5,'FontSize',18)

%% Problem Definiton

% if else commands based on the problem.Model is deleted temporarily

problem.Model = input_data.textdata;
problem.numVariables  = size(input_data.data,2);
problem.variableMin = input_data.data(1,:);
problem.variableMax = input_data.data(2,:);

problem.Nd = size(w_freq,1); % Number of data points
problem.expData = [ w_freq'; Ep_data'; Epp_data']; % experimental data
problem.modelData = [w_freq'; zeros(size(Ep_data,1),1)'; zeros(size(Epp_data,1),1)']; % model data
problem.weight = [0.5, 0.5];

%% Parameters of PSO
% Coefficient construction; proposed by Clerck and Kennedy 2003
kappa = 1;
phi1 = 2.01;
phi2 = 2.01;
phi = phi1 + phi2;
chi = 2*kappa/abs(2-phi-sqrt(phi^2-4*phi));
params.maxIterations = input_data.data(3,1);        % Maximum Number of Iterations
params.swarmSize = input_data.data(3,2);         % Population Size
params.inertiaVector = linspace(0.9, 0.4, params.maxIterations);  % ********** New inertia coefficient ********** %
params.personalAccCoeff = chi*phi1;                       % Personal Acceleration Coefficient
params.socialAccCoeff = chi*phi2;                       % Social Acceleration Coefficient
params.showIterationInfo = true;                 % Flag for Showing Iteration Informatin

%% Calling PSO in Loop
run_cnt = 1;
n_run = 50;
BestSols = zeros(n_run, problem.numVariables+2);

for i=1:n_run
    clc
    rng('shuffle');
    out = PSO(problem,params,i);
    BestSol = out.bestSolution;
    bestCosts = out.bestCosts;
    datanorm = problem.weight(1)*norm(log(Ep_data),2)^2+problem.weight(2)*norm(log(Epp_data),2)^2;
    LSE = sqrt(bestCosts(end)/datanorm)*100;
    BestSols(i, 1:problem.numVariables) = BestSol.position; % Optimized fitting parameters
    BestSols(i, problem.numVariables+1) = BestSol.cost;     % Optimized cost
    BestSols(i, problem.numVariables+2) = LSE;              % Error
    run_cnt = run_cnt + 1;
end

%% Data Modification
E_01 = BestSols(:,1); tauc_1 = BestSols(:,2); alpha_1 = BestSols(:,3); beta_1 = BestSols(:,4);
E_02 = BestSols(:,5); tauc_2 = BestSols(:,2).*(BestSols(:,1)./BestSols(:,5)).^0.5;
alpha_2 = BestSols(:,6); beta_2 = BestSols(:,7);
LSE = BestSols(:,problem.numVariables+2);

% Omitting out of range data
sf = 1.01;
% if LSE = sf*min(LSE) is true, the corresponding data point is omitted %

E_01(LSE>sf*min(BestSols(:,problem.numVariables+2))) = [];alpha_1(LSE>sf*min(BestSols(:,problem.numVariables+2))) = [];
tauc_1(LSE>sf*min(BestSols(:,problem.numVariables+2))) = [];beta_1(LSE>sf*min(BestSols(:,problem.numVariables+2))) = [];

E_02(LSE>sf*min(BestSols(:,problem.numVariables+2))) = [];alpha_2(LSE>sf*min(BestSols(:,problem.numVariables+2))) = [];
tauc_2(LSE>sf*min(BestSols(:,problem.numVariables+2))) = [];beta_2(LSE>sf*min(BestSols(:,problem.numVariables+2))) = [];

% Determining the original index of remaining data points
LSE(LSE>sf*min(BestSols(:,problem.numVariables+2))) = 0; indicies = find((LSE')); LSE(LSE==0) = [];

% Sometimes, this algorithm assigns the alpha1 value to beta1 and vice versa
% The code below will correct this mistake.
for i=1:size(alpha_1,1)
    if alpha_1(i)<beta_1(i)
        temp = alpha_1(i);
        alpha_1(i) = beta_1(i);
        beta_1(i) = temp;
    end
end

% Modified best solutions
BestSols_Modif = zeros(size(LSE,1),problem.numVariables+1);
BestSols_Modif(:,1) = E_01;BestSols_Modif(:,2) = tauc_1;BestSols_Modif(:,3) = alpha_1;BestSols_Modif(:,4) = beta_1;
BestSols_Modif(:,5) = E_02;BestSols_Modif(:,6) = tauc_2;BestSols_Modif(:,7) = alpha_2;BestSols_Modif(:,8) = beta_2;
BestSols_Modif(:,9) = LSE;

%% Monitoring Modified Fitting Parameters Variation vs. Number of Runs
Lwidth = 2.5;
Msize = 10;
Fsize = 18;

TFsize = 26;
YFsize = 26;

figure(1)
% LSE
plot(1:1:size(LSE,1),BestSols_Modif(:,9),'-o','LineWidth',Lwidth,'MarkerSize',Msize);
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
xlabel('$Run \:Numbers$','FontSize',YFsize,'FontWeight','bold','Interpreter','Latex')
ylabel('$LSE (\%)$','FontSize',YFsize,'Interpreter','Latex')
% ylim([1.6, 3.5])

%%
figure(2)
% E0,1
subplot(4,2,1); plot(1:1:size(LSE,1),BestSols_Modif(:,1),'-o','LineWidth',Lwidth,'MarkerSize',Msize);
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
ylabel('$E_{0,1} \:(MPa)$','FontSize',YFsize,'Interpreter','Latex')
title({'$FMM_{1}$'},{'$10^{3}{\le}E_{0,1}{\le}10^{4}$'},'Interpreter','Latex','FontSize',TFsize)
ylim([2170,2190])

% E0,2
subplot(4,2,2); plot(1:1:size(LSE,1),BestSols_Modif(:,5),'-o','LineWidth',Lwidth,'MarkerSize',Msize);
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
ylabel('$E_{0,2} \:(MPa)$','FontSize',YFsize,'Interpreter','Latex')
title({'$FMG_{2}$'},{'$10^{1}{\le}E_{0,2}{\le}10^{3}$'},'Interpreter','Latex','FontSize',TFsize)
ylim([70,90])

% taupersonalAccCoeff
subplot(4,2,3); plot(1:1:size(LSE,1),BestSols_Modif(:,2),'-o','LineWidth',Lwidth,'MarkerSize',Msize);
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
ylabel('$\tau_{c,1} \:(s)$','FontSize',YFsize,'Interpreter','Latex')
title({'$10^{-3}{\le}\tau_{c,1}{\le}10^{1}$'},'Interpreter','Latex','FontSize',TFsize)
ylim([0.7,0.8])

% tauc2
subplot(4,2,4); plot(1:1:size(LSE,1),tauc_2,'-o','LineWidth',Lwidth,'MarkerSize',Msize);
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
ylabel('$\tau_{c,2} \:(s)$','FontSize',YFsize,'Interpreter','Latex')
title({'$\tau_{c,2}$'},'Interpreter','Latex','FontSize',TFsize)
ylim([3.8,4])

% alpha1
subplot(4,2,5); plot(1:1:size(LSE,1),BestSols_Modif(:,3),'-o','LineWidth',Lwidth,'MarkerSize',Msize);
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
ylabel('$\alpha_{1}$','FontSize',YFsize,'Interpreter','Latex')
title({'$0{\le}\alpha_{1}{\le}1$'},'Interpreter','Latex','FontSize',TFsize)
ylim([0, 1])

% alpha2
subplot(4,2,6); plot(1:1:size(LSE,1),BestSols_Modif(:,7),'-o','LineWidth',Lwidth,'MarkerSize',Msize);
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
ylabel('$\alpha_{2}$','FontSize',YFsize,'Interpreter','Latex')
title({'$0{\le}\alpha_{2}{\le}1$'},'Interpreter','Latex','FontSize',TFsize)
ylim([0, 1])

% beta1
subplot(4,2,7); plot(1:1:size(LSE,1),BestSols_Modif(:,4),'o-','LineWidth',Lwidth,'MarkerSize',Msize);
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
xlabel('$Run \:Numbers$','FontSize',YFsize,'FontWeight','bold','Interpreter','Latex')
ylabel('$\beta_{1}$','FontSize',YFsize,'Interpreter','Latex')
title({'$0{\le}\beta_{1}{\le}1$'},'Interpreter','Latex','FontSize',TFsize)
ylim([0, 1])

% beta2
subplot(4,2,8); plot(1:1:size(LSE,1),BestSols_Modif(:,8),'o-','LineWidth',Lwidth,'MarkerSize',Msize);
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
xlabel('$Run \:Numbers$','FontSize',YFsize,'FontWeight','bold','Interpreter','Latex')
ylabel('$\beta_{2}$','FontSize',YFsize,'Interpreter','Latex')
title({'$\beta_{2}=0$'},'Interpreter','Latex','FontSize',TFsize)
ylim([0, 1])

%% Mean value and std dev for the modified results
mean_modif_fitting_param = zeros(1, problem.numVariables+2);
std_modif_fitting_param = zeros(1, problem.numVariables+2);
for i=1:problem.numVariables+2
    mean_modif_fitting_param(1, i) = mean(BestSols_Modif(:,i));
    std_modif_fitting_param(1, i) = std(BestSols_Modif(:,i));
end

%% E_prime & E_dprime based on optimized fitted parameters
plt_num = indicies; % Plotting top results (the remaining data points after modification)
% plt_num = 1:1:50; % Plotting all the results

n_plt = size(plt_num,2);
E_prime = zeros(n_plt,size(w_freq,1));
E_dprime = zeros(n_plt,size(w_freq,1));
problem = Constitutive_Model(problem, BestSols(1, 1:problem.numVariables));
E_prime(1, :) = problem.modelData(2,:);
E_dprime(1, :) = problem.modelData(3,:);
for i=1:n_plt
    problem = Constitutive_Model(problem, BestSols(plt_num(i), 1:problem.numVariables));
    E_prime(i, :) = problem.modelData(2,:);
    E_dprime(i, :) = problem.modelData(3,:);
end

%% Multiple Eprime plots
hold on
box on
set(gca, 'YScale', 'log','XScale','log','LineWidth',Lwidth,'FontSize',Fsize)
lgnd_cnt = 1;
plot(w_freq, Ep_data,'ob','LineWidth',Lwidth,'MarkerSize',Msize)
legends{lgnd_cnt} = sprintf('$Experimental Data$');
lgnd_cnt = lgnd_cnt + 1;

for i=1:n_plt   
    plot(problem.modelData(1,:),E_prime(i,:),'*','MarkerSize',Msize)
    num = plt_num(i);
    legends{lgnd_cnt} = sprintf('$Run Number %d$', num);
    lgnd_cnt = lgnd_cnt + 1;
end

legend(legends,'Location','southeast','FontSize',18,'Interpreter','Latex')
xlabel('$\omega aT \:(rad/s)$','Interpreter','Latex')
ylabel('$E{\prime}\:(MPa)$','Interpreter','Latex')
grid('on')
hold off

%% Multiple Edprime plots
hold on
box on
set(gca, 'YScale', 'log','XScale','log','LineWidth',Lwidth,'FontSize',Fsize)
lgnd_cnt = 1;
plot(w_freq, Epp_data,'ob','LineWidth',Lwidth,'MarkerSize',Msize)
legends{lgnd_cnt} = sprintf('$Experimental Data$');
lgnd_cnt = lgnd_cnt + 1;

for i=1:n_plt   
    plot(problem.modelData(1,:),E_dprime(i,:),'*','MarkerSize',Msize)
    num = plt_num(i);
    legends{lgnd_cnt} = sprintf('$Run Number %d$', num);
    lgnd_cnt = lgnd_cnt + 1;
end

legend(legends,'Location','southeast','FontSize',18,'Interpreter','Latex')
xlabel('$\omega aT \:(rad/s)$','Interpreter','Latex')
ylabel('$E{\prime\prime}\:(MPa)$','Interpreter','Latex')
grid('on')
hold off

%% Single plots
BestParams = mean_modif_fitting_param(1:problem.numVariables+1);
BestParams(6)=[];
problem = Constitutive_Model(problem, BestParams);
E_prime_single = problem.modelData(2,:);
E_dprime_single = problem.modelData(3,:);

Ep_data(w_freq<10^(-8)) = [];
Epp_data(w_freq<10^(-8)) = [];
E_prime_single(w_freq<10^(-8)) = [];
E_dprime_single(w_freq<10^(-8)) = [];
w_freq(w_freq<10^(-8)) = [];

Epp_data(w_freq>10^2) = [];
Ep_data(w_freq>10^2) = [];
E_prime_single(w_freq>10^2) = [];
E_dprime_single(w_freq>10^2) = [];
w_freq(w_freq>10^2) = [];

hold on
box on
set(gca, 'YScale', 'log','XScale','log','LineWidth',Lwidth,'FontSize',Fsize)
plot(w_freq, Ep_data,'ok','LineWidth',Lwidth,'MarkerSize',Msize)
plot(w_freq, Epp_data,'^k','LineWidth',Lwidth,'MarkerSize',Msize)
plot(w_freq,E_prime_single,'-b','MarkerSize',Msize,'LineWidth',Lwidth+2)
plot(w_freq,E_dprime_single,'-r','MarkerSize',Msize,'LineWidth',Lwidth+2)
xlabel('$\omega aT \:(rad/s)$','Interpreter','Latex')
ylabel('$E^{\prime} \& E^{\prime\prime}\:(MPa)$','Interpreter','Latex')
ylim([10^-1,10^4])
grid('on')
hold off
legend('Storage - Data', 'Loss - Data', 'Storage - FMM-FMG', 'Loss - FMM-FMG','location','southeast')

w_freq_20HS_00GnP = w_freq;
Ep_Exp_20HS_00GnP = Ep_data;
Epp_Exp_20HS_00GnP = Epp_data;
Ep_Model_20HS_00GnP = E_prime_single;
Epp_Model_20HS_00GnP = E_dprime_single;

save('20HS_00GnP.mat', 'w_freq_20HS_00GnP', 'Ep_Exp_20HS_00GnP', 'Epp_Exp_20HS_00GnP', 'Ep_Model_20HS_00GnP', 'Epp_Model_20HS_00GnP')
%% Convergence
set(gca,'LineWidth',Lwidth,'FontSize',Fsize)
loglog(bestCosts,'LineWidth',Lwidth)
set(gca,'YScale','log','XScale','log','LineWidth',Lwidth,'FontSize',Fsize)
xlabel('$Iterations$','Interpreter','Latex')
ylabel('$Best \:Cost$','Interpreter','Latex')