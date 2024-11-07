function cost = Cost_Function(problem, params)

% This function calculates a multi-objective cost value for the
% optimization via:
% z = w1*(log(E'_exp / E'_model))^2 + w1*(log(E''_exp / E''_model))^2

problem = Constitutive_Model(problem, params);

f1 = norm(log(problem.expData(2,:)) - log(problem.modelData(2,:)))^2;
f2 = norm(log(problem.expData(3,:)) - log(problem.modelData(3,:)))^2;

cost = problem.weight(1)*f1 + problem.weight(2)*f2;

end
