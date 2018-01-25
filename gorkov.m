function [potential] = gorkov(p, px, py, pz, radius)
%GORKOV Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('radius','var')
      radius = 1e-3;
    end
    V = 4/3*pi*radius.^3;
    omega = 2*pi*40e3;
    c_0 = 346.13;%Ljudhastigheten luft
    c_p = 1498;%I vatten
    rho_0 = 1.1839;%Densitet
    rho_p = 997;
    K_1 = V/4*( 1./(c_0.^2*rho_0) - 1./(c_p.^2*rho_p));
    K_2 = 3/4*V*( (rho_0-rho_p)./(omega^2*rho_0*(rho_0 + 2*rho_p)) );
    
    potential = K_1*abs(p).^2 - K_2.*(abs(px).^2 + abs(py).^2 + abs(pz).^2);
end

