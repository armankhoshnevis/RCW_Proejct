classdef testConstitutiveModel < matlab.unittest.TestCase
    methods (Test)
        function testNominalValues(testCase)
            % Test with nominal parameter values
            % Set up the problem structure (first row: frequency)
            problem.modelData = [logspace(-8, 2, 11); zeros(2, 11)];
            
            % Define parameter values
            params = [2000, 2, 0.3, 0.0, 300, 0.08, 0.0];
            
            % Calculate the storage and loss modules
            addpath('../src');
            problem = Constitutive_Model(problem, params);
            
            % NaN or Inf check for both modules
            testCase.verifyFalse(any(isnan(problem.modelData(2,:))), 'Storage module contains NaN values');
            testCase.verifyFalse(any(isinf(problem.modelData(2,:))), 'Storage module contains Inf values');
            testCase.verifyFalse(any(isnan(problem.modelData(3,:))), 'Loss module contains NaN values');
            testCase.verifyFalse(any(isinf(problem.modelData(3,:))), 'Loss module contains Inf values');
        end
        
        function testEdgeCaseValues(testCase)
            % Test with edge parameter values
            problem.modelData = [logspace(-8, 2, 11); zeros(2, 11)];
            
            % Define edge-case parameter values
            params = [2000, 2.0, 0.0, 0.0, 300, 1.0, 1.0];

            addpath('../src');
            problem = Constitutive_Model(problem, params);
            
            % NaN or Inf check for both modules
            testCase.verifyFalse(any(isnan(problem.modelData(2,:))), 'Storage module contains NaN values');
            testCase.verifyFalse(any(isinf(problem.modelData(2,:))), 'Storage module contains Inf values');
            testCase.verifyFalse(any(isnan(problem.modelData(3,:))), 'Loss module contains NaN values');
            testCase.verifyFalse(any(isinf(problem.modelData(3,:))), 'Loss module contains Inf values');
        end

        function testSanityCheck(testCase)
            % Sanity Checks on Output Range
            problem.modelData = [logspace(-8, 2, 11); zeros(2, 11)];
            params = [2000, 2, 0.3, 0.0, 300, 0.08, 0.0];
            
            addpath('../src');
            problem = Constitutive_Model(problem, params);
            
            % Non-negative check for both modules
            testCase.assertGreaterThanOrEqual(problem.modelData(2,:), 0, 'Storage module contains negative values');
            testCase.assertGreaterThanOrEqual(problem.modelData(3,:), 0, 'Loss module contains negative values');
        end
    end
end
