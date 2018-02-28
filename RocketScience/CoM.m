function[X_com, Y_com, Z_com] = CoM(c,Throttle, n, SolidFuelLeft, jettison)
% CoM(Throttle, c.timestep, n, SolidFuelLeft, jettison)
% calculates the centre of mass of the entire shuttle
% dynamically recalculated to factor in fuel used
%
% Returns the centre of mass X, Y, Z co-ordinates in that order

Constants;

LOXLeft = LOX - 3*Throttle*LOXpS*c.timestep*n;
LH2Left = LH2 - 3*Throttle*LH2pS*c.timestep*n;
galLOX = gallonsOX -gallonsOXpS*n*c.timestep;
galLH2 = gallonsH2 -gallonsH2pS*n*c.timestep;

%X is the "width", 0 is middle
%Y is the "height", 0 is bottom
%Z is the "depth", 0 is center of tank

%for everything but SRBs, X is 0.
%diameter of SRB = 12.17 feet (google)
X_norm = 0;
X_SRB = c.SRBdiam/2 + c.extTankDiameter/2; %diameters of the tanks + SRB
%However, since the SRBs are matched, we can safely
%ignore the distance from the center, since it should cancel out anyway

%total height of space shuttle is 184.2 feet
%SRBs are 149.16 feet
%orbiter is 122.17 feet
%fore tank 54.6 feet
%aft tank 97 feet

%Now the fancy parts
%volume of solid fuel is based on the mass
%first we need the density though
density_solidfuel = (weightSolidFuel)/(pi*((c.SRBdiam/2)^2)*149.16); %lb/ft^3
%to get the current CoM of the solid fuel, we work back from the mass left
Y_SolFuel = (((SolidFuelLeft/2)/density_solidfuel)/(pi*((c.SRBdiam/2)^2)))/2;
Y_Sol1 = (((weightSolidFuel/2)/density_solidfuel)/(pi*((c.SRBdiam/2)^2)))/2;
%same goes for liquid fuels
%need to figure out the mass of the fuel thing here

%volume of cylinder = pi*r^2*h
%height = V/(pi*r^2)
Y_LOX = (((galLOX*c.galtofoot)/(pi*((c.extTankDiameter/2)^2)))/2) + (184.2-54.6);
Y_LH2 = (184.2 - (97+54.6))+ ((galLH2*c.galtofoot)/(pi*((c.extTankDiameter/2)^2)))/2;
Y_O1 = (((gallonsOX*c.galtofoot)/(pi*((c.extTankDiameter/2)^2)))/2) + (184.2-54.6);
Y_H1 = (184.2 - (97+54.6))+ ((gallonsH2*c.galtofoot)/(pi*((c.extTankDiameter/2)^2)))/2;

%Again, Z is 0 for all but the orbiter
Z_norm = 0;

%These calculations are for working out the centre of mass of the orbiter
Z_fin = 17.31/12; %location of original Z
Orb2ground = 37; %height of orbiter above ground

Y_fin = 68+Orb2ground; %original centre of mass location
%While working on this, I found that for the centre of mass of the orbiter
%not to be significantly outside the orbiter, the height of the orbiter
%needed to be the above, worked out manually

Z_Orb = ((Z_fin*(extTank+LH2+LOX+c.weightEmptyBooster*2+weightOrbiter+weightSolidFuel*2) ...
    -(Z_norm*(extTank+LOX+LH2+c.weightEmptyBooster*2+weightSolidFuel*2))))/weightOrbiter;

Y_Orb = (Y_fin*(extTank+LH2+LOX+weightSolidFuel+c.weightEmptyBooster*2+weightOrbiter) ...
    - ((c.Y_tank*extTank)+(c.Y_SRB*2*c.weightEmptyBooster)+(Y_Sol1*weightSolidFuel)+(Y_O1*LOX)+(Y_H1*LH2)))/weightOrbiter;

%Now, we finally get the final CoM pieces
%Ignoring X_norm for calculation since it's just 0 anyway
X_com = ((X_SRB*c.weightEmptyBooster*jettison/2)+(X_SRB*-1*c.weightEmptyBooster*jettison/2) ... 
    +(X_SRB*SolidFuelLeft*0.25*jettison)+(X_SRB*SolidFuelLeft*0.25*jettison*-1)) ...
    /(c.weightEmptyBooster*jettison + SolidFuelLeft*0.5*jettison);

Y_com = ((c.Y_tank*extTank)+(c.Y_SRB*jettison*c.weightEmptyBooster)+((Y_SolFuel)*SolidFuelLeft) ...
    +((Y_LOX)*LOXLeft)+((Y_LH2)*LH2Left)+(Y_Orb*weightOrbiter)) ... 
    /(extTank+LOXLeft+LH2Left+SolidFuelLeft+c.weightEmptyBooster*jettison+weightOrbiter);

Z_com = ((Z_norm*(extTank+c.weightEmptyBooster*jettison+SolidFuelLeft+LOXLeft+LH2Left)) ...
    + (Z_Orb*weightOrbiter))/(extTank+c.weightEmptyBooster*jettison+weightOrbiter+SolidFuelLeft+LOXLeft+LH2Left);

