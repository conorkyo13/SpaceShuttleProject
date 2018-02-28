lb2slug = 0.031081; %needed to solve F=ma
SolidFuelpS = [1107000/124];
weightSolidBooster = 1107000+193000; %weight in lbs fuel + fuel container
weightSolidFuel = 1107000;
c.weightEmptyBooster = 193000;
weightOrbiter = 217513; %lbs of the bit the astronauts are in
extTank = 78100; %lbs container
%LH2 = 234265;%lbs liquid hydrogen in lbs
%LO2 = 1387457; %liquid oxygen forward tank in lbs

c.lb_conv = 0.062428;
c.sealevelP = 101325;
c.feet2m = 0.3048;
%constants for drag
c.extTankDiameter = 27.6; %feet
c.extTankCrossArea = pi*c.extTankDiameter^2/4;
c.SRBdiam = 12.7;
c.SRBarea = pi*c.SRBdiam^2/4;
c.OrbArea = 220*501/144;

Throttle = [0.9*ones(1,30/c.timestep),.65*ones(1,32/c.timestep),1.04*ones(1,456/c.timestep), zeros(1,100)];

g = 9.80665; %m/s^2
rhoZero = 14.7; %14.7 psi, converted to psf

%density of fuels
D_LOX = 9.527; %lb/gal
D_LH2 = 0.5906; %lb/gal
%The effect of pressure on the densities of fluids is negligible, according
%to wikipedia we would need over 10,000 atm to cause a 1% impact

 
 
%Fuel usage calculations
LiquidFuelUsed = 0;
gallonsOX = 146181.8; %starting fuel of liquid oxygen in gallons
gallonsH2 = 395581.9; %starting fuel of liquid hydrogen in gallons
LOX = gallonsOX*D_LOX; %LOX mass, lb
LOXLeft = LOX;
LH2 = gallonsH2*D_LH2; %LH2 mass, lb
LH2Left = LH2;
c.FullExtTank = extTank + LOX + LH2;
%all values are given for 100% throttle
gallonsOXpS = 350*gallonsOX/(gallonsOX+gallonsH2); %gallons used per second
gallonsH2pS = 350*gallonsH2/(gallonsOX+gallonsH2); %gallons used per second
LOXpS = gallonsOXpS*LOX/gallonsOX; %lbs used per second
LH2pS = gallonsH2pS*LH2/gallonsH2; %lbs used per second
LFuelpS = LOXpS+LH2pS; %total liquid fuel expelled per second per rocket (there are three)

standardGravity = 32.174049; %feet/sec^2
c.galtofoot = 0.133681; %conversion ratio for gallons to cubic feet

c.Y_SRB = 149.16/2; %COM of cylinder is at the middle
%The COM of the tank is easy. The fuel inside is the
%complicated part. 
c.Y_tank = 184.2 - (97+54.6)/2;

c.LFuelpS = 1.0507e+03;
c.weightSolidFuel = 1107000;
c.SolidFuelpS = 8927.419354838;

c.RadiusEarth = 20.9*10^6; %feet
c.standardGravity = 32.174049; %feet/sec^2

toRads = pi/180;
%angle of the acceleration, based on the data we obtained from sts 119
%                             0 secs              15secs
c.ThrustAngle = [89*ones(1,15/c.timestep),68*ones(1,15/c.timestep)];
%                             35secs               45secs
c.ThrustAngle = [c.ThrustAngle,64*ones(1,20/c.timestep),61.3*ones(1,10/c.timestep)];
%                             75secs              105secs
c.ThrustAngle = [c.ThrustAngle,59.1*ones(1,30/c.timestep),38.7*ones(1,30/c.timestep)];
%                             135secs              150secs
c.ThrustAngle = [c.ThrustAngle,19*ones(1,30/c.timestep),21*ones(1,90/c.timestep)];
%                             240secs             270secs
c.ThrustAngle = [c.ThrustAngle,30*ones(1,30/c.timestep),25*ones(1,30/c.timestep)];
%                             300secs             330secs
c.ThrustAngle = [c.ThrustAngle,20*ones(1,30/c.timestep),25*ones(1,30/c.timestep)];
%                             360secs             420secs
c.ThrustAngle = [c.ThrustAngle,17*ones(1,60/c.timestep),7.5*ones(1,30/c.timestep)];
%                             450secs             480secs
c.ThrustAngle = [c.ThrustAngle,4.8*ones(1,30/c.timestep),2*ones(1,120/c.timestep)];

c.ThrustAngle = c.ThrustAngle*toRads;
