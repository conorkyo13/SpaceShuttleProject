function handle = orbiter(c,thrustAngle,ThrustFromShuttleAngle, ThrusterAngle, n, Thrust)
%handle = orbiter(thrustAngle,ThrustFromShuttleAngle, ThrusterAngle, n, c.timestep, Thrust)
%Function draws a single frame of the space shuttle in flight, showing the
%remaining stages and a vector showing the thrust
%All inputs are necessary
%       thrustAngle-the direction of thrust
%       ThrustFromShuttleAngle-the difference between the thrust direction
%       and the direction which the rocket actually points
%       ThrusterAngle-direction of the main engines
%       n - the frame number
%       c.timestep-the time in seconds between discrete time values, needed
%       for creating the constants in the constants file
%       Thrust-Magnitude of the Thrust, for drawing the thrust vector
%       Returns the handle which the shuttle was drawn in

%V1 06/05/2016
%Renders the tanks and the orbiter
%V2 07/05/2016
%Renders the tank, the orbiter and angel the thrusters
%V3 08/05/2016

    theAngle = thrustAngle+ThrustFromShuttleAngle; %the overall orientation of the rocket
    Z_Orb = 29.988384616289370; %the distance from the Centre of Mass of the Orbiter to the centre of the main tank
    Orb2ground = 37; %height of the Orbiter from the ground
    Constants; %Some of the measurements used in this file are needed

    %axis limits should be a cube so the model isn't distorted
    cube = [-150 150 -100 200 -50 250]; 
    %Artistic choices
    figurePos = [100 100 850 600];
    lightingOne = [-1 -1 -1];
    lightingTwo = [0 0 -.8];
    camera = [-70 -10];
	handle = figure('Position',figurePos);
	axis(cube)
	light('Position',lightingOne); axis square
    axis off
	light('Position',lightingTwo)
    
	view(camera) %an approximately side on view shows the movement best
    if(n < 520) %Draw the external Tank
        DrawDomedCone([0,0,184.2-(97+54.6)],theAngle,(97+54.6),c.extTankDiameter/2,c.extTankDiameter/2,[1,.4,0]); %Draw the external Tank
    else %Draw a representation of it being jettisoned
        DrawDomedCone([0,0,184.2-(97+54.6)],theAngle+.3*(n-520)/20,(97+54.6),c.extTankDiameter/2,c.extTankDiameter/2,[1,.4,0]); 
    end  
    
    if(n < 124) %Draw the SRBs
        DrawDomedCone([-(c.extTankDiameter+c.SRBdiam)/2,0,0],theAngle,149.16,c.SRBdiam/2,c.SRBdiam/2,[1,1,1]);
        DrawDomedCone([(c.extTankDiameter+c.SRBdiam)/2,0,0],theAngle,149.16,c.SRBdiam/2,c.SRBdiam/2,[1,1,1]);
    elseif(n >124 && n <130) %Draw them being Jettisoned
        DrawDomedCone([-(c.extTankDiameter+c.SRBdiam)/2,0,0],theAngle+.5*(n-124)/6,149.16,c.SRBdiam/2,c.SRBdiam/2,[1,1,1]);
        DrawDomedCone([(c.extTankDiameter+c.SRBdiam)/2,0,0],theAngle+.5*(n-124)/6,149.16,c.SRBdiam/2,c.SRBdiam/2,[1,1,1]);
    end
    %else they will not be drawn
    
    %Describe the orbiter, represented by a very simplistic six point 3D shape
    vertOrbiter = [ ([-39 -10 0 10 39 0])' ([0 0 0 0 0 -50]-(Z_Orb-15))' ([0 30 121 30 0 0]+Orb2ground)'];
    faces = [1 2 3 4 5; 1 2 6 6 6; 2 3 6 6 6; 3 4 6 6 6; 4 5 6 6 6; 1 5 6 6 6];
    Rtheta = [1 0 0; 0 cos(theAngle) sin(theAngle);0 -sin(theAngle) cos(theAngle)]; %matrix for applying rotation
    vertOrbiterRotated = zeros(200,3); %initialising rotated vertices matrix 
    %   Move it into alignment with the other space shuttle components
    for count = 1:size(vertOrbiter)
        vertOrbiterRotated(count,:) = (Rtheta*(vertOrbiter(count,:)'))';
    end
    patch('Vertices',vertOrbiterRotated,'Faces',faces,'FaceColor',[1,1,1],'LineStyle','none');
    %Angle the Thrusters by the extra amount needed.
    ThrusterAngle = pi/2 - ThrusterAngle;
    DrawDomedCone([0,-35, 15],theAngle+ThrusterAngle,18,6,10,[.6,.6,0.6]);
    
    %Draw the angle of Acceleration
    if(n<519)
    DrawDomedCone([0,25, 70],thrustAngle,Thrust/50000,2,2,[0,0,0]);
    end