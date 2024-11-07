function out = PSO(problem, params, run_number)
    %% Problem Definition
    numVariables = problem.numVariables; % Number of Decision Variables
    variableSize = [1 numVariables]; % Size of Decision Variables Matrix
    variableMin = problem.variableMin; % Lower Bound of Decision Variables
    variableMax = problem.variableMax; % Upper Bound of Decision Variables

    %% Parameters of PSO
    maxIterations = params.maxIterations; % Maximum Number of Iterations
    swarmSize = params.swarmSize; % Population Size (Swarm Size)
    inertiaVector = params.inertiaVector; % Inertia Coefficient
    personalAccCoeff = params.personalAccCoeff; % Personal Acceleration Coefficient
    socialAccCoeff = params.socialAccCoeff; % Social Acceleration Coefficient

    % The Flag for Showing Iteration Information
    showIterationInfo = params.showIterationInfo; % Flag for Showing Iteration Information
    maxVelocity = 0.2*(variableMax-variableMin); 
    minVelocity = -maxVelocity;
    
    %% Initialization
    % Particle Template
    emptyParticle.position = [];
    emptyParticle.velocity = [];
    emptyParticle.cost = [];
    emptyParticle.best.position = [];
    emptyParticle.best.cost = [];

    % Create Population Array
    particles = repmat(emptyParticle, swarmSize, 1);

    % Initialize Global Best
    globalBest.cost = inf;

    % Data for Plotting
    plotMaxY = zeros(swarmSize, 1);
	dataMatrix = [];

    % Initialize Population
    for i=1:swarmSize
        % Generate Random Solution
        particles(i).position = problem.variableMin + ...
            (problem.variableMax - problem.variableMin) .* rand(1, problem.numVariables);
        
        % Initialize Velocity
        particles(i).velocity = zeros(variableSize);

        % Evaluate Cost
        particles(i).cost = Cost_Function(problem, particles(i).position);
        plotMaxY(i) = particles(i).cost;
                
        % Update Personal Best
        particles(i).best.position = particles(i).position;
        particles(i).best.cost = particles(i).cost;

        % Update Global Best
        if particles(i).best.cost < globalBest.cost
            globalBest = particles(i).best;
        end
    end
    
    % Get Maximum Objective Function Value from Initialization Step
    plotMax = max(plotMaxY);
    
    % Array to Hold Best Cost Value for Each Iteration
    bestCosts = zeros(maxIterations, 1);

    %% Main Loop of PSO
    for iteration=1:maxIterations
        % Update Inertia Weight
        inertiaWeight = inertiaVector(iteration);
        
        for i=1:swarmSize
            % Update Velocity
            particles(i).velocity = inertiaWeight*particles(i).velocity ...
                + personalAccCoeff*rand(variableSize).*(particles(i).best.position - particles(i).position) ...
                + socialAccCoeff*rand(variableSize).*(globalBest.position - particles(i).position);
            
            % Apply Velocity Limits
            particles(i).velocity = max(particles(i).velocity, minVelocity);
            particles(i).velocity = min(particles(i).velocity, maxVelocity);
            
            % Update Position
            particles(i).position = particles(i).position + particles(i).velocity;

            % Apply Lower and Upper Bound Limits
            particles(i).position = max(particles(i).position, variableMin);
            particles(i).position = min(particles(i).position, variableMax);
            
            % Evaluate Cost
            particles(i).cost = Cost_Function(problem, particles(i).position);
            
            % Update Personal Best
            if particles(i).cost < particles(i).best.cost
                
                particles(i).best.position = particles(i).position;
                particles(i).best.cost = particles(i).cost;
                
                % Update Global Best
                if particles(i).best.cost < globalBest.cost
                    globalBest = particles(i).best;
                end
                
            end
            
        end
        
        % Store Best Cost Value
        bestCosts(iteration) = globalBest.cost;
        
        % Display Iteration Information
        if mod(iteration, 100) == 0 && showIterationInfo
            LSE = 100 * sqrt(bestCosts(iteration)) / sqrt(problem.weight(1) * norm(problem.expData(2, :), 2)^2 + problem.weight(2) * norm(problem.expData(3, :), 2)^2);
		    MSE = bestCosts(iteration) / size(problem.expData, 2);
            fprintf('Run number %d, Iteration %d, Cost = %.16e, LSE = %.16e, MSE = %.16e\n', run_number, iteration, bestCosts(iteration), LSE, MSE);
            disp(globalBest.position);
			dataMatrix = [dataMatrix; iteration, LSE, MSE, globalBest.position];
        end
        
    end
    
    % Output
    out.population = particles;
    out.bestSolution = globalBest;
    out.bestCosts = bestCosts;
	out.outputData = dataMatrix;
end
