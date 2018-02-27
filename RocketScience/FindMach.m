function [mach] = FindMach(velocity,T)
% FindMach(velocity,temperature)
% finds the mach at which the space shuttle is travelling at
%
% v 1.2

gammaR = 20.05; %constant from equation for the speed of sound using the variables R (ideal gas constant) and gamma
feet2m = 3.28084;
vsound = gammaR*sqrt(T)*feet2m; % speed of sound at the temperature we are
mach = velocity/vsound; % mach 1 is the speed of sound