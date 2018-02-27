clear
set_var
Constants

%The main loop
for(n = 1:secsFinish/timestep)
    
    if(n>124/timestep)
        jettison=0;
    else
        jettison=2; %else there are 2 SRBs
    end 

    velocity(n) = sqrt(perpVelocity(n)^2+tangVelocity(n)^2);
    
    %k1=
    [SolidFuelLeft,LiquidFuelUsed,mass(n),TotalExtTank] = Weight(FullExtTank,LiquidFuelUsed,weightEmptyBooster, Throttle(n), timestep, jettison, t(n));
    [DragForce(n),pressure(n),Temp(n),Cd,CdOrb,DynamicPressure(n)] = Drag(velocity(n),height(n),jettison,Mach(n));
    [gravity(n), CentripetalAccl(n),effectiveGravity(n)] = Centripetal(height(n), tangVelocity(n));
    [MaxThrust(n),SolidRocketThrust(n), MainEngineThrust(n)] = Thrust(pressure(n),jettison,Throttle(n),n,timestep);
    accl(n) = (MaxThrust(n)-DragForce(n))/mass(n); %pound of force/slug of mass = feet/s^2
    perpAcclk1 = (accl(n)*sin(ThrustAngle(n)) -effectiveGravity(n));
    tangAcclk1 = accl(n)*cos(ThrustAngle(n));
    k1 = sqrt(perpAcclk1^2 + tangAcclk1^2);
    
    %k2 =
    [~,~,massk2,~] = Weight(FullExtTank,LiquidFuelUsed,weightEmptyBooster, Throttle(n+1), timestep, jettison, t(n+1));
    [DragForcek2,~,~,~,~,~] = Drag(velocity(n)+k1,height(n),jettison,Mach(n));
    [~, ~,effectiveGravityk2] = Centripetal(height(n), tangVelocity(n)+tangAcclk1);
    [MaxThrustk2,~, ~] = Thrust(pressure(n),jettison,Throttle(n+1),n+1,timestep);
    acclk2 = (MaxThrustk2-DragForcek2)/massk2;
    perpAcclk2 = acclk2*sin(ThrustAngle(n+1)) -effectiveGravityk2;
    tangAcclk2 = acclk2*cos(ThrustAngle(n+1));
    
    perpVelocity(n+1) = perpVelocity(n) + timestep*1/2*(perpAcclk1+perpAcclk2);
    tangVelocity(n+1) = tangVelocity(n) + timestep*1/2*(tangAcclk1+tangAcclk2);
    height(n+1) = height(n) + perpVelocity(n)*timestep;
    range(n+1) = range(n) + tangVelocity(n)*timestep; 
    [X_com(n),Y_com(n),Z_com(n)] = CoM(Throttle(n),timestep,n,SolidFuelLeft,jettison);
    Mach(n) = FindMach(velocity(n),((Temp(n)-32)/1.8) + 273.15); %T degrees faranheight to kelvin
    realAccl(n) = sqrt(perpAcclk1^2+tangAcclk1^2);
end
GForce = accl/standardGravity;
tmins = t/60;
plot(tmins,height)