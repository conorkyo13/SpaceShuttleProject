function [gravity, CentripetalAccl,effectiveGravity] = Centripetal(height, tangVelocity)
%[gravity, CentripetalAccl,effectiveGravity] = Centripetal(height, tangVelocity)
%height is height from the ground measured in feet
%tangVelocity is the velocity of the shuttle parallel to the ground (in feet)
RadiusEarth = 20.9*10^6; %feet
standardGravity = 32.174049; %feet/sec^2
gravity = standardGravity - 3.18e-6*height; %linear relationship of gravity found using information given
RadiusFromCentreEarth = RadiusEarth + height;
CentripetalAccl = (tangVelocity^2)/RadiusFromCentreEarth;
effectiveGravity = (gravity-CentripetalAccl);
if(effectiveGravity<0)
    effectiveGravity=0;
end