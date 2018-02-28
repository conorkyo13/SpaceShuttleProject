%% Initialize the arrays of measurements we are interested in
clear
c.timestep = 0.1; % s
secsFinish = 8*60+40; % s
steps = secsFinish/c.timestep;
t = [0:c.timestep:secsFinish];

% Everything in Imperial units
[ perpVelocity, Temp, height, velocity, Mach, DragForce, accl, ...
  CentripetalAccl, airDensity, DynamicPressure, mass, X_com, ...
  Y_com, Z_com, pressure, MainEngineThrust, MaxThrust, ...
  tangVelocity, acclUp, SolidFuelLeft, gravity, Y_model, Z_model, ...
  range, effectiveGravity, SolidRocketThrust, realAccl ] ...
= deal(zeros(1,steps));
n=1;
Constants

%% The main loop, runs the 8min40sec launch
for(n = 1:steps)
    if(n>124/c.timestep)
        jettison=0;
    else
        jettison=2; %else there are 2 SRBs
    end 

    velocity(n) = sqrt(perpVelocity(n)^2+tangVelocity(n)^2);
    [SolidFuelLeft,LiquidFuelUsed,mass(n),TotalExtTank] = ...
        Weight(c, LiquidFuelUsed, Throttle(n), jettison, t(n));
    [DragForce(n),pressure(n),Temp(n),Cd,CdOrb,DynamicPressure(n)] = ...
        Drag(c,velocity(n),height(n),jettison,Mach(n));
    [gravity(n), CentripetalAccl(n), effectiveGravity(n)] = ...
        Centripetal(c,height(n), tangVelocity(n));
    [MaxThrust(n),SolidRocketThrust(n), MainEngineThrust(n)] = ...
        Thrust(c,pressure(n), jettison, Throttle(n), n);
    
    accl(n) = (MaxThrust(n)-DragForce(n))/mass(n); %pound of force/slug of mass = feet/s^2
    perpAccl = (accl(n)*sin(c.ThrustAngle(n)) -effectiveGravity(n));
    tangAccl = accl(n)*cos(c.ThrustAngle(n));
    Accl = sqrt(perpAccl^2 + tangAccl^2);
    
    perpVelocity(n+1) = perpVelocity(n) + c.timestep*(perpAccl);
    tangVelocity(n+1) = tangVelocity(n) + c.timestep*(tangAccl);
    height(n+1) = height(n) + perpVelocity(n)*c.timestep;
    range(n+1) = range(n) + tangVelocity(n)*c.timestep; 
    [X_com(n),Y_com(n),Z_com(n)] = CoM(c,Throttle(n),n,SolidFuelLeft,jettison);
    Mach(n) = FindMach(velocity(n),((Temp(n)-32)/1.8) + 273.15); %T degrees faranheight to kelvin
    realAccl(n) = sqrt(perpAccl^2+tangAccl^2);
end
GForce = accl/standardGravity;
tmins = t/60;
plot(tmins,height)

%% Animate the launch
close all
Trajectory = AnimateTrajectory(height,range,n);
movie2avi(Trajectory, 'Trajectory.avi', 'compression', 'None');
close all
AnimateShuttle
movie2avi(CloseUp, 'Shuttle.avi', 'compression', 'None');