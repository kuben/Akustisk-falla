function [minLapl] = BFGS1(startPosition)
% Calculates a minimum of the laplacian of the Gor'kov
% given a start position.
% Needs lapl.m.

    minLapl = fminunc(@lapl,startPosition);
end
