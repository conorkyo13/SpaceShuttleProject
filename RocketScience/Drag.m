function [DragForce,pressure,T,Cd,CdOrb,DynamicPressure] = Drag(velocity,height,jettison,Mach)
% Drag(velocity,height,jettison,Mach)
%
% To find the overall drag force of the space shuttle
% Uses the Mach at which the space shuttle is travelling at to find the
% drag coeffiencts, while using the height to determine the temperature and
% pressure at which we are at.
%
% v 3.2


%constants
extTankDiameter = 27.6; %feet
extTankCrossArea = pi*extTankDiameter^2/4;
SRBdiam = 12.7;
SRBarea = pi*SRBdiam^2/4;
OrbArea = 220*501/144;

%nasa's earth atmosphere model given in imperial units

if (height < 36152) %troposphere
    T = 59 - 0.00356*height; %Temp is in degrees faranheight
    pressure = 2116*((T + 459.7)/518.6)^5.256; %lbs/ft^2
elseif (height < 82345) %lower stratosphere
    T = -70;
    pressure = 473.1*exp(1.73-0.000048*height);
else %upper stratosphere
    T = -205.05 + 0.00164*height;
    pressure = 51.97*((T + 459.7)/389.98)^-11.388;
end

if Mach < 0.8 % modelling of drag coefficients as given
    Cd = 0.25;
    CdOrb = 0.75;
    
elseif Mach < 1
    Cd = 0.25 + (1.3-0.25)/(.2)*(Mach - 0.8);
    CdOrb = 0.75 + (2.5-0.75)/(1-0.8)*(Mach - 0.8);
            
elseif Mach < 2
     Cd = 1.3 + (0.4-1.3)*(Mach - 1);
     CdOrb = 2.5 + (1.4-2.5)*(Mach - 1);
   
else
     Cd = 0.4;
     CdOrb = 1.4;
end

airDensity = pressure/(1718*(T + 459.7)); %slugs/ft^3
DynamicPressure = 1/2*airDensity*velocity^2;
DragForce = Cd*extTankCrossArea*DynamicPressure + jettison*Cd*SRBarea*DynamicPressure + CdOrb*OrbArea*DynamicPressure;

