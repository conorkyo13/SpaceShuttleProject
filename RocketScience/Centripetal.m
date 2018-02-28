function [gravity, CentripetalAccl,effectiveGravity] = Centripetal(c,height, tangVelocity)
%[gravity, CentripetalAccl,effectiveGravity] = Centripetal(height, tangVelocity)
%height is height from the ground measured in feet
%tangVelocity is the velocity of the shuttle parallel to the ground (in feet)

gravity = c.standardGravity - 3.18e-6*height; %linear relationship of gravity found using information given
RadiusFromCentreEarth = c.RadiusEarth + height;
CentripetalAccl = (tangVelocity^2)/RadiusFromCentreEarth;
effectiveGravity = (gravity-CentripetalAccl);
if(effectiveGravity<0) % Safeguard against model which only works for a range
    effectiveGravity=0;
end