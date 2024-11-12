% In this script, we run the PSO optimization for numRuns and save the
% output

% Read .dat file
clc;
close all;
format long e;

addpath('PSOSetup/');
filename = 'FMG_FMG_20HS_05GnP_Test.dat';
fid = fopen(filename, 'r');

sheetName = fgetl(fid);
validRange = fgetl(fid);

modelName = fgetl(fid);

lower_bounds_line = fgetl(fid);
lower_bounds = sscanf(lower_bounds_line, '%e');
uppper_bounds_line = fgetl(fid);
upper_bounds = sscanf(uppper_bounds_line, '%e');

pso_setup = fscanf(fid, '%e', 3);

% Read and Split the Experimental Data
addpath('../../data/');
tableData = readmatrix("Summary for New Master Curves 7-22-23.xlsx", ...
    'Sheet', sheetName, 'Range', validRange);
frequencyData = tableData(:,1);
epData = tableData(:,2);
eppData = tableData(:,3);

% Problem Definiton
problem.model = modelName;
problem.numVariables = size(lower_bounds', 2);
problem.variableMin = lower_bounds';
problem.variableMax = upper_bounds';

problem.expData = [frequencyData'; epData'; eppData']; % Experimental Data
problem.modelData = [frequencyData'; zeros(size(epData, 1), 1)'; zeros(size(eppData, 1), 1)']; % Model Data

problem.weight = [0.5, 0.5]; % Weights for cost function

% Parameters of PSO
% Coefficient Construction; Proposed by Clerck and Kennedy 2003
kappa = 1;
phi1 = 2.01;
phi2 = 2.01;
phi = phi1 + phi2;
chi = 2 * kappa / abs(2 - phi - sqrt(phi^2 - 4 * phi));

params.maxIterations = pso_setup(1);
params.swarmSize = pso_setup(2);
params.inertiaVector = linspace(0.9, 0.4, params.maxIterations);
params.personalAccCoeff = chi * phi1;
params.socialAccCoeff = chi * phi2;
params.showIterationInfo = true;

% Calling PSO in Loop
runCount = 1;
numRuns = pso_setup(3);
bestSolutions = zeros(numRuns, problem.numVariables + 2);

for i = 1:numRuns
    clc;
    rng('shuffle');
    out = PSO(problem, params, i);
    bestSol = out.bestSolution;
    bestCosts = out.bestCosts;
    dataNorm = problem.weight(1) * norm(log(epData), 2)^2 + problem.weight(2) * norm(log(eppData), 2)^2;
    LSE = sqrt(bestCosts(end) / dataNorm) * 100;
    bestSolutions(i, 1:problem.numVariables) = bestSol.position;
    bestSolutions(i, problem.numVariables + 1) = bestSol.cost;
    bestSolutions(i, problem.numVariables + 2) = LSE;
    runCount = runCount + 1;
end

% Save the optimization data
fgetl(fid);
matlabData = fgetl(fid);
savePath = fullfile('OptimizationResults', 'FMG_FMG', matlabData);
save(savePath);

% Convergence plot
% Lwidth = 2.5;
% Msize = 10;
% Fsize = 18;
% set(gca, 'LineWidth', Lwidth, 'FontSize', Fsize);
% loglog(bestCosts, 'LineWidth', Lwidth);
% set(gca, 'YScale', 'log', 'XScale', 'log', 'LineWidth', Lwidth, 'FontSize', Fsize);
% xlabel('$Iterations$', 'Interpreter', 'Latex');
% ylabel('$Best \:Cost$', 'Interpreter', 'Latex');
