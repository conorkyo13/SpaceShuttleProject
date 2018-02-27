function DrawDomedCone(position,theta, len, topRadius, BottomRadius, FaceColour)
%DrawDomedCone(position, theta, len, topRadius, BottomRadius, FaceColour) 
%none of the arguments are optional 
%Draws a domed conic section where the dome radius and bottom of cone 
%radius can both be changed
%The shape is then put at the desired position then rotated about the axis

N = 100; %Create a 100 sided polygon as an approximation of a conic section
phi = [0:2*pi/N:(2*pi)-(2*pi/N)]'; 
vertices1 = [topRadius*cos(phi) topRadius*sin(phi) len*ones(N,1)]; %top disc
vertices2 = [BottomRadius*cos(phi) BottomRadius*sin(phi) zeros(N,1)]; %bottom disc
vertices = [vertices1;vertices2]; %combining all the vertices 
faces_all = [[1:N];[1:N]' [[2:N] 1]' [(N+[2:N]) N+1]' ((N+[1:N])')*ones(1,N-3);N+[1:N]]; %describing how the vertices connect
Rtheta = [1 0 0; 0 cos(theta) sin(theta);0 -sin(theta) cos(theta)]; %matrix for applying rotation
positionMatrix = repmat(position,200,1);
vertices = vertices + positionMatrix;
vertices_rod_rotated = zeros(200,3); %initialising rotated vertices matrix 
for count = 1:2*N
 vertices_rod_rotated(count,:) = (Rtheta*(vertices(count,:)'))';
end
%draw the conic section
patch('Vertices',vertices_rod_rotated,'Faces',faces_all,'FaceColor',FaceColour,'LineStyle','none');

[x,y,z] = sphere(40); %Create a sphere
[f,v,~] = surf2patch(x,y,z,z);
thing = size(v);
v = topRadius*v; %give it the radius of the top conic section
%position the sphere so that it forms the top dome of the cone
v = v + [position(1)*ones(thing(1),1),position(2)*ones(thing(1),1),(len+position(3))*ones(thing(1),1)];
%rotate it to where the cone is
vertices_sphere_rotated = zeros(200,3); %initialising rotated vertices matrix 
for count = 1:thing
 vertices_sphere_rotated(count,:) = (Rtheta*(v(count,:)'))';
end
patch('Vertices',vertices_sphere_rotated,'Faces',f,'FaceColor',FaceColour,'LineStyle','none'); 
