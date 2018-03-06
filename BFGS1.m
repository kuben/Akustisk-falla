function [minLapl,minLaplVal] = BFGS1(startPosition)
% Calculates a minimum of the laplacian of the Gor'kov
% given a start position.
% Needs laplFun.m.
    options = optimoptions('fminunc', 'SpecifyObjectiveGradient', true, ... 'HessUpdate','bfgs'...
    'OptimalityTolerance',1e-6,'MaxFunctionEvaluations',100*3,...
    'StepTolerance',1e-8);
    [minLapl,minLaplVal] = fminunc(@laplFun,startPosition,options);
end
