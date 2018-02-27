function [ThrustFromShuttleAngle,theta, AvgCount, MaxCount] = AngleThrusters(MainEngineThrust,Throttle,Y_com, Z_com, Z_Orb, Orb2ground, SolidRocketThrust, timestep)
%[ThrustFromShuttleAngle,theta,thetadegrees, AvgCount, MaxCount] = AngleThrusters(MainEngineThrust,Throttle,Y_com, Z_com, Z_Orb, Orb2ground, SolidRocketThrust, timestep)
%The function returns the angle of the Thrust with comparison to the shuttle orientation 
%the angle of the main engines and some iteration statistics
%It is assumed that the shuttle only rotates in a singular plane
%V3
    SRBgimbal = 87/360*2*pi; %The angle of thrust of the Solid Rocket Boosters
    theta = 80/360*2*pi*ones(1,520/timestep); %initialise the thruster angle
    thetadegrees = theta;
    ThrustFromShuttleAngle = theta;
    AvgCount = 0;
    MaxCount = 0;
    for n = 1:520/timestep
        solution = 1;
        count=0;
        %As is the same as elsewhere in this project, the SRBs are jettisoned by multiplying them by 2
        if(n<=124/timestep) 
            jettison = 2;
        else
            jettison = 0;
        end
        if(Throttle(n) && MainEngineThrust(n))
            while(abs(solution)>10^-5 && count<100)
                count = count+1;
                %The turning force of the SRBs around the centre of mass
                %must equal the turning force of the main engine thrust
                %The moment of each force is separated into upward and
                %left/right components
                %Clockwise components are positive
                solution = 3*MainEngineThrust(n)*Throttle(n)*((Y_com(n)-Orb2ground)*cos(theta(n)) - (Z_Orb-Z_com(n))*sin(theta(n))) -Z_com(n)*SolidRocketThrust(n)*jettison*sin(SRBgimbal) +Y_com(n)*SolidRocketThrust(n)*jettison*cos(SRBgimbal);
                Dsolution = 3*MainEngineThrust(n)*Throttle(n)*(-(Y_com(n)-Orb2ground)*sin(theta(n)) - (Z_Orb-Z_com(n))*cos(theta(n)));
                theta(n) = theta(n) - solution/Dsolution;
                theta(n) = rem(theta(n),2*pi);
            end
            AvgCount = AvgCount + count;
            if(count>MaxCount)
                MaxCount = count;
            end
            thetadegrees(n) = theta(n)*360/(2*pi);
            %Find the resultant force direction with regards to the angle
            %of the shuttle (using the main tank angle as 0)
            adj = 3*MainEngineThrust(n)*Throttle(n)*(cos(theta(n))) +SolidRocketThrust*jettison*sin(SRBgimbal)*cos(SRBgimbal);
            opp = 3*MainEngineThrust(n)*Throttle(n)*(sin(theta(n))) +Z_com(n)*SolidRocketThrust*jettison*sin(SRBgimbal);
            ThrustFromShuttleAngle(n) = atan(adj/opp);
        else
            theta(n) = theta(n-1);
            thetadegrees(n) = thetadegrees(n-1);
            ThrustFromShuttleAngle(n) = ThrustFromShuttleAngle(n-1);
        end
            
    end
    AvgCount = AvgCount/n;