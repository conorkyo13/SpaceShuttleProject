function[X_com, Y_com, Z_com] = CoM(Throttle, timestep, n, SolidFuelLeft, jettison)
% CoM(Throttle, timestep, n, SolidFuelLeft, jettison)
% calculates the centre of mass of the entire shuttle
% dynamically recalculated to factor in fuel used
%
% Returns the centre of mass X, Y, Z co-ordinates in that order
% V3.0 - converted to function
% V2.1 - finalised orbiter original centre of mass
% V2.0 - static orbiter centre of mass, but negative Y value
% V1.5 - dynamic effect of jettison added
% V1.4 - LOX and LH2 locations updated based on new data
% V1.3 - dynamic effect of LOX and LH2 added
% V1.2 - changing amounts of solid fuel included
% V1.1 - X location calculated
% V1.0 - physical centre of mass, X set to zero
% V0.1 - placeholder values to allow program to run


Constants;

galtofoot = 0.133681; %conversion ratio for gallons to cubic feet
LOXLeft = LOX - 3*Throttle*LOXpS*timestep*n;
LH2Left = LH2 - 3*Throttle*LH2pS*timestep*n;
galLOX = gallonsOX -gallonsOXpS*n*timestep;
galLH2 = gallonsH2 -gallonsH2pS*n*timestep;

%X is the "width", 0 is middle
%Y is the "height", 0 is bottom
%Z is the "depth", 0 is center of tank

%for everything but SRBs, X is 0.
%diameter of SRB = 12.17 feet (google)
X_norm = 0;
X_SRB = SRBdiam/2 + extTankDiameter/2; %diameters of the tanks + SRB
%However, since the SRBs are matched, we can safely
%ignore the distance from the center, since it should cancel out anyway

%total height of space shuttle is 184.2 feet
%SRBs are 149.16 feet
%orbiter is 122.17 feet
%fore tank 54.6 feet
%aft tank 97 feet
Y_SRB = 149.16/2; %COM of cylinder is at the middle
%The COM of the tank is easy. The fuel inside is the
%complicated part. 
Y_tank = 184.2 - (97+54.6)/2;
%Now the fancy parts
%volume of solid fuel is based on the mass
%first we need the density though
density_solidfuel = (weightSolidFuel)/(pi*((SRBdiam/2)^2)*149.16); %lb/ft^3
%to get the current CoM of the solid fuel, we work back from the mass left
Y_SolFuel = (((SolidFuelLeft/2)/density_solidfuel)/(pi*((SRBdiam/2)^2)))/2;
Y_Sol1 = (((weightSolidFuel/2)/density_solidfuel)/(pi*((SRBdiam/2)^2)))/2;
%same goes for liquid fuels
%need to figure out the mass of the fuel thing here

%volume of cylinder = pi*r^2*h
%height = V/(pi*r^2)
Y_LOX = (((galLOX*galtofoot)/(pi*((extTankDiameter/2)^2)))/2) + (184.2-54.6);
Y_LH2 = (184.2 - (97+54.6))+ ((galLH2*galtofoot)/(pi*((extTankDiameter/2)^2)))/2;
Y_O1 = (((gallonsOX*galtofoot)/(pi*((extTankDiameter/2)^2)))/2) + (184.2-54.6);
Y_H1 = (184.2 - (97+54.6))+ ((gallonsH2*galtofoot)/(pi*((extTankDiameter/2)^2)))/2;

%Again, Z is 0 for all but the orbiter
Z_norm = 0;

%These calculations are for working out the centre of mass of the orbiter
Z_fin = 17.31/12; %location of original Z
Orb2ground = 37; %height of orbiter above ground

Y_fin = 68+Orb2ground; %original centre of mass location
%While working on this, I found that for the centre of mass of the orbiter
%not to be significantly outside the orbiter, the height of the orbiter
%needed to be the above, worked out manually

Z_Orb = ((Z_fin*(extTank+LH2+LOX+weightEmptyBooster*2+weightOrbiter+weightSolidFuel*2)-(Z_norm*(extTank+LOX+LH2+weightEmptyBooster*2+weightSolidFuel*2))))/weightOrbiter;

Y_Orb = (Y_fin*(extTank+LH2+LOX+weightSolidFuel+weightEmptyBooster*2+weightOrbiter) - ((Y_tank*extTank)+(Y_SRB*2*weightEmptyBooster)+(Y_Sol1*weightSolidFuel)+(Y_O1*LOX)+(Y_H1*LH2)))/weightOrbiter;

%Now, we finally get the final CoM pieces
%Ignoring X_norm for calculation since it's just 0 anyway
X_com = ((X_SRB*weightEmptyBooster*jettison/2)+(X_SRB*-1*weightEmptyBooster*jettison/2)+(X_SRB*SolidFuelLeft*0.25*jettison)+(X_SRB*SolidFuelLeft*0.25*jettison*-1))/(weightEmptyBooster*jettison + SolidFuelLeft*0.5*jettison);
Y_com = ((Y_tank*extTank)+(Y_SRB*jettison*weightEmptyBooster)+((Y_SolFuel)*SolidFuelLeft)+((Y_LOX)*LOXLeft)+((Y_LH2)*LH2Left)+(Y_Orb*weightOrbiter))/(extTank+LOXLeft+LH2Left+SolidFuelLeft+weightEmptyBooster*jettison+weightOrbiter);
Z_com = ((Z_norm*(extTank+weightEmptyBooster*jettison+SolidFuelLeft+LOXLeft+LH2Left)) + (Z_Orb*weightOrbiter))/(extTank+weightEmptyBooster*jettison+weightOrbiter+SolidFuelLeft+LOXLeft+LH2Left);

