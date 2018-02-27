timestep = 0.1;
[ThrustFromShuttleAngle,theta, AvgCount, MaxCount] = AngleThrusters(MainEngineThrust,Throttle,Y_com, Z_com, Z_Orb, Orb2ground, SolidRocketThrust, timestep);
ThrustFromShuttleAngle(5201:5400) = ThrustFromShuttleAngle(5200);
theta(5201:5400) = theta(5200); %Beyond this time the engines are turned off, the angle is left whereever it ends up
MaxThrust(5201:5400) = MaxThrust(5200);
for(n = 1:540) %Add some extra time to show the External tank being jettisoned
    handle = orbiter(-(ThrustAngle(n/timestep)-pi/2),-ThrustFromShuttleAngle(n/timestep),theta(n/timestep),n,timestep, MaxThrust(n/timestep));
    MyFilm(n) = getframe(handle);
   close(handle)
end
movie2avi(MyFilm, 'SHu.avi', 'compression', 'None');