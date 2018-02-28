function [MaxThrust,SolidRocketThrust, MainEngineThrust] = Thrust(c,pressure,jettison,Throttle,n)
% Thrust(pressure,jettison,Throttle,n,c.timestep)
% Sets the combined thrust of the Main Engines and two SRBs
%
% returns max thrust and the Solid Rocket Thrust
% v 2.0

if (n <= 50/c.timestep)
    SolidRocketThrust = 3.1e6; % researching we found that the SRB thrust is equal to 3,100,000 lbs of force at sea level
else
    SolidRocketThrust = 2.65e6; % decreases to 2,650,000 after 50 seconds to help the space shuttle through Max Q
end

if (n <= 519/c.timestep) %zero thrust, main engine cutoff at this point
    MainEngineThrust = 470000 - (470000-375000)/14.709*pressure/144; % linear relationship formula we devised given the information
else
    MainEngineThrust = 0;
end
 
MaxThrust = SolidRocketThrust*jettison + 3*MainEngineThrust*Throttle; %lbs of force