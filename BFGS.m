function [minLaplPhase,minLaplVal] = BFGS(pos,startPhase)
% Calculates a minimum of the laplacian of the Gor'kov
% potential at a position pos, from given a startphase.
% Needs laplFunPhase.m.
    T = Transducer.list_transducers();    
    
    if ~exist('startPhase','var'), startPhase = zeros(1,length(T)); end
    
    opts = optimoptions('fminunc',... 'SpecifyObjectiveGradient', true,
    'HessUpdate','bfgs',...
    'OptimalityTolerance',1e-8,'MaxFunctionEvaluations',100*length(T),...
    'StepTolerance',1e-8);

    function BFGSinit_val = BFGSinit(phase)
        BFGSinit_val = laplFunPhase(pos,phase,false);
    end
    
    [minLaplPhase,minLaplVal] = fminunc(@BFGSinit,startPhase,opts);
end
