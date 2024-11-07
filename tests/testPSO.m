classdef testPSO < matlab.unittest.TestCase
    methods (Test)
        function testParameterBoundaries(testCase)
            % Read the PSO Setup
            addpath('../src/PSO/PSOSetup/');
            filename = 'FMG_FMG_20HS_05GnP_Test.dat';
            fid = fopen(filename, 'r');
            
            sheetName = fgetl(fid);
            validRange = fgetl(fid);
            fgetl(fid); % Skipp the Model Name
            
            lower_bounds_line = fgetl(fid);
            lower_bounds = sscanf(lower_bounds_line, '%e');
            uppper_bounds_line = fgetl(fid);
            upper_bounds = sscanf(uppper_bounds_line, '%e');
            
            pso_setup = fscanf(fid, '%e', 3);
            
            % Experimental Data
            addpath('../data/');
            tableData = readmatrix("Summary for New Master Curves 7-22-23.xlsx", ...
                'Sheet', sheetName, 'Range', validRange);
            frequencyData = tableData(:,1);
            epData = tableData(:,2);
            eppData = tableData(:,3);

            % Setup the problem
            problem.numVariables = size(lower_bounds', 2);
            problem.variableMin = lower_bounds';
            problem.variableMax = upper_bounds';
            
            problem.expData = [frequencyData'; epData'; eppData'];
            problem.modelData = [frequencyData'; zeros(size(epData, 1), 1)'; zeros(size(eppData, 1), 1)'];
            problem.weight = [0.5, 0.5];

            % Parameters for PSO
            addpath('../src/PSO/');
            params.maxIterations = pso_setup(1);
            params.swarmSize = pso_setup(2);
            params.inertiaVector = linspace(0.9, 0.4, params.maxIterations);
            kappa = 1;
            phi1 = 2.01;
            phi2 = 2.01;
            phi = phi1 + phi2;
            chi = 2 * kappa / abs(2 - phi - sqrt(phi^2 - 4 * phi));
            params.personalAccCoeff = chi * phi1;
            params.socialAccCoeff = chi * phi2;
            params.showIterationInfo = false;

            % Run PSO for Testing
            numRuns = pso_setup(3);
            rng('shuffle');
            out = PSO(problem, params, numRuns);

            % Check if all optimized parameters are within bounds
            optimizedPosition = out.bestSolution.position;
            testCase.assertGreaterThanOrEqual(optimizedPosition, problem.variableMin, ...
                'One or more optimized parameters are below the lower bound.');
            testCase.assertLessThanOrEqual(optimizedPosition, problem.variableMax, ...
                'One or more optimized parameters exceed the upper bound.');

            % Verify that the global best cost is non-increasing
            bestCosts = out.bestCosts;
            testCase.assertTrue(all(diff(bestCosts) <= 0), ...
                'Global best cost should be non-increasing over iterations.');
        end
    end
end
