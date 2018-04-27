function [minLaplPhase,minLaplVal] = BFGS(pos,startPhase,randomStart,randomStartNumPoints,presFactor)
% Calculates a minimum of the laplacian of the Gor'kov
% potential at a position pos, from given a start phase.
% Needs lapl.m.
% Ex:
% BFGS(pos,startPhase,randomStart,randomStartNumPoints)
% 
% pos is the position where - the laplacian of the Gor'kov potential is
% optimised
% startPhase is from where the optimisation starts
% randomStart is if you want a randomised start phase. startPhase is
% therefore rendered obsolete?
% randomStartNumPoints is the number of phases that are randomised

    T = Transducer.list_transducers();    
    
    if ~exist('startPhase','var') || isempty(startPhase)
        for i = 1:length(T)
            startPhase(i) = T(i).phase;
        end
    elseif length(startPhase) ~= length(T)
        startPhase(length(startPhase)+1:length(T)) = zeros(1,length(phase)+1:length(T));
        warning('Length of phase vector not equal to number of Transducers. Trying anyway.')
    end
    if ~exist('randomStart','var'), randomStart = false; end
    if ~exist('randomStartNumPoints','var'), randomStartNumPoints = 100; end
    if ~exist('presFactor','var'), presFactor = 0; end
        
    if randomStart == true
        testPhase = ((pi/2)*randn(randomStartNumPoints,length(T)));
        testPhase(randomStartNumPoints+1,:) = startPhase;
        testVal = zeros(1,randomStartNumPoints+1);
        for i = 1:randomStartNumPoints+1
            testVal(i) = laplFunPhase(pos,testPhase(i,:));
        end
        [~,I] = min(testVal);
        startPhase = testPhase(I,:);
    end
    
    opts = optimoptions('fminunc',... 'SpecifyObjectiveGradient', true,
    'HessUpdate','bfgs',...
    'OptimalityTolerance',1e-2,'MaxFunctionEvaluations',100*length(T),...
    'StepTolerance',1e-2);

    function BFGSinit_val = BFGSinit(phase)
        [laplacian_gor,tryck_tot] = laplFunPhase(pos,phase,false);
        BFGSinit_val = laplacian_gor+presFactor*tryck_tot;
    end
    
    [minLaplPhase,minLaplVal] = fminunc(@BFGSinit,startPhase,opts);
end
