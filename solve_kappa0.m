% =========================================================================
% INTRODUCTION
%	- Calculate the pure-tone attenuation coefficient due to the atmospheric
%       absorption based on the standard ISO 9613-1.
% -------------------------------------------------------------------------
% INPUT
%	N_FHT		- number of sampling points
%	n_FHT		- vector of [0:N_FHT-1]
% OUTPUT
%	a        	- exponential coefficients of geometric series \alpha
%	k0      	- interpolation coefficient
%   x1          - normalized sampling points' coordinates in \rho direction
%	x0      	- first element of x1
% =========================================================================

function [a , k0 , x1 , x0] = solve_kappa0(N_FHT , n_FHT)
syms x
a = vpasolve(exp(x*(1-N_FHT)) == (1-exp(-x)),x);
a = real(double(a));
x0 = ((1+exp(a)) * exp(-a*N_FHT) / 2);
x1 = x0 * exp(a*n_FHT);
k0 = (2*exp(a) + exp(2*a)) / ((1+exp(a))^2 * (1-exp(-2*a)));
end