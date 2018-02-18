function MyFilm = JansenLeg(pace, repetitions, lengths, angles)
%MyFilm = JansenLeg
%MyFilm = JansenLeg(pace,repetition)
%MyFilm = JansenLeg(pace, repetition, lengths, angles)
%The function animates a Jansen Leg.
%Movement of this leg is achieved by a crank.
%JansenLeg called with no arguments runs with default values of pace repetition lengths and angles.
%The pace is set in steps per second, repetitions is the number of steps taken
%The lengths and angles can also be input although without decent initial angle guesses,
%the function cannot understand the shape of the proposed JansenLeg

ZeroOneX = -38; %Distance on the x axis between the first and second fixed point
ZeroOneY = -7.8; %Distance on the y axis between the first and second fixed point
angleFixed = pi+atan(ZeroOneY/ZeroOneX); %Changing to vector form so it works for the closure function
lengthFixed = sqrt(ZeroOneX^2+ZeroOneY^2);

switch nargin 
	case 0
		pace=0.25;
		repetitions=1;
		setvects=1;
	case 2
		setvects=1;
	case 4
		setvects=0;
	otherwise
		error('Invalid inputs');
end
if(setvects)
	lengths = [15,41.5,50,61.9,39.3,55.8,40.1,39.4,36.7,65.7,49, lengthFixed]; 
%		Lengths of the connecting struts of the Jansen Leg in the order
%       Crank one_j i_j i_heel one_heel j_knee one_knee
%       knee_ankle ankle_heel ankle_toe heel_toe

angles = [0;1.5;3;-2.5;-2;1;.5;-2;-1;-2;-1; angleFixed]; 
%		Initial guesses of the angles of the struts along with the known angles
%		The same order as lengths
end
points = 24/pace;
anglesOut = zeros(points,12);

timestep = 0;
for theta = [0:points-1]*2*pi/points; %Don't double dip
    angles(1)=theta;
    timestep = timestep+1;
    angles([3 2]) = SolveClosureEq([lengths([1 12 3 2])],[angles([1 12 3 2])]); %Solve the upper quadrilateral 1 0 i j
    angles([4 5]) = SolveClosureEq([lengths([1 12 4 5])],[angles([1 12 4 5])]); %Solve the quadrilateral 1 0 i heel 
    angles([6 7]) = SolveClosureEq([lengths(2),0, lengths([6 7])],[angles(2);0;angles([6 7])]); %Solve the triangle 1 j knee
	angles([8 9]) = SolveClosureEq(lengths([7 5 8 9]),angles([7 5 8 9])); %Solve the quadrilateral 1 knee ankle heel
	angles([10 11]) = SolveClosureEq([lengths(9),0, lengths([10 11])],[angles(9);0;angles([10 11])]); %Solve the triangle ankle heel toe (the foot)
    anglesOut(timestep,:)= angles'; %store the solutions for this angle 
end

%Find the joint positions using the solved angles with the lengths
zero = zeros(points,2);
one = [ZeroOneX*ones(points,1),ZeroOneY*ones(points,1)];
i = lengths(1)*[cos(anglesOut(:,1)),sin(anglesOut(:,1))];
j = i+lengths(3)*[cos(anglesOut(:,3)),sin(anglesOut(:,3))];
knee = j+lengths(6)*[cos(anglesOut(:,6)),sin(anglesOut(:,6))];
heel = i+lengths(4)*[cos(anglesOut(:,4)),sin(anglesOut(:,4))];
toe = heel+lengths(11)*[cos(anglesOut(:,11)),sin(anglesOut(:,11))];
ankle = heel+lengths(9)*[cos(anglesOut(:,9)),sin(anglesOut(:,9))];
%It's not actually necessary to have all of the joint locations

figurePos = [100 100 850 600];
cube = [-80 50 -120 10 -90 40]; %axis limits should be a cube so the model isn't distorted
lightingOne = [-1 -1 -1];
lightingTwo = [0 0 -.8];
camera = [-40 10];
M = 1;
while M<points 
	%Draw the eleven Links as cylinders in their correct positions
	%for each of the points necessary to animate a full rotation at 24FPS 
	handle = figure('Position',figurePos);
	axis(cube)
	light('Position',lightingOne); axis off
	light('Position',lightingTwo)
	view(camera) %an approximately side on view shows the movement best
	DrawLink(zero(M,:),anglesOut(M,1),lengths(1));
	DrawLink(one(M,:),anglesOut(M,2),lengths(2));
	DrawLink(i(M,:),anglesOut(M,3),lengths(3));
	DrawLink(i(M,:),anglesOut(M,4),lengths(4));
	DrawLink(one(M,:),anglesOut(M,5),lengths(5));
	DrawLink(j(M,:),anglesOut(M,6),lengths(6));
	DrawLink(one(M,:),anglesOut(M,7),lengths(7));
	DrawLink(knee(M,:),anglesOut(M,8),lengths(8));
	DrawLink(heel(M,:),anglesOut(M,9),lengths(9));
	DrawLink(ankle(M,:),anglesOut(M,10),lengths(10));
	DrawLink(heel(M,:),anglesOut(M,11),lengths(11));
	MyFilm(M) = getframe(handle); 
	%Once all eleven Links have been drawn capture the model before closing the figure to remove them
close(handle)
M=M+1;
end
if(repetitions~=1)
    MyFilm = repmat(MyFilm,1,repetitions);
end

function AnglesOut = SolveClosureEq(Clengths, Cangles)
%AnglesOut = SolveClosureEq(Clengths, Cangles);
%The function takes in four known lengths and two known angles, as well as two initial guesses at the unknown angles
%The vector Cangles should be of the form [known;known;guess;guess]. It is a column vector.
%The vector Clengths should give the four known lengths of Links, in the same order as the related angles. Clengths is a row vector.

	toterance=10^-5;
	iterationLimit=200;
	NumberFails=0;
	f=[1,1];
    iteration=0;
    while((abs(f(1))>10^-5 || abs(f(2))>10^-5) && iteration < iterationLimit) %Two variable Newton-Raphson method
    	iteration=iteration+1;
		%f is [x component equation; y component equation]
        f = [Clengths(1)*cos(Cangles(1))+Clengths(3)*cos(Cangles(3))-Clengths(2)*cos(Cangles(2))-Clengths(4)*cos(Cangles(4));Clengths(1)*sin(Cangles(1))+Clengths(3)*sin(Cangles(3))-Clengths(2)*sin(Cangles(2))-Clengths(4)*sin(Cangles(4))];
        %Df is [dx/dangle3,dx/dangle4;dy/dangle3,dy/dangle4]
		Df = [-Clengths(3)*sin(Cangles(3)),Clengths(4)*sin(Cangles(4));Clengths(3)*cos(Cangles(3)),-Clengths(4)*cos(Cangles(4))];
		%Update guess
        Cangles(3:4) = Cangles(3:4) - (inv(Df)*f);
		%There are many solutions, one occurring every 2*pi, all valid and usable, but the first +/-2pi radians are easiest to visualise
        Cangles(3:4) = rem(Cangles(3:4),2*pi); 
    end
	if(iteration==200)
        error('Unable to solve the shape')
    end
	AnglesOut = Cangles([3 4]);
    
function DrawLink(position,theta, len)
%DrawLink(position,theta, len) none of the arguments are optional 
%Draws a cylindrical link given one of the joints it is connected to and the angle at which it is orientated

theta = -(theta+pi/2); %This is necessary due to the initial position of the Link
position(2:3) = position(1:2);
position(1) = 0; %All the joint share a common plane, this was chosen to be zero 
%The construction of the link is taken from the method outlined in sim2 notes, hence it is called a rod
N = 100; %Create a 100 sided polygon as an approximation of a cylinder
r_rod = 1; %radius of the rod
phi = [0:2*pi/N:(2*pi)-(2*pi/N)]'; 
vertices1_rod = [r_rod*cos(phi) r_rod*sin(phi) zeros(N,1)]; %top disc
vertices2_rod = [r_rod*cos(phi) r_rod*sin(phi) -len*ones(N,1)]; %bottom disc
vertices_rod = [vertices1_rod;vertices2_rod]; %combining all the vertices 
faces_all = [[1:N];[1:N]' [[2:N] 1]' [(N+[2:N]) N+1]' ((N+[1:N])')*ones(1,N-3);N+[1:N]]; %describing how the vertices connect
Rtheta = [1 0 0; 0 cos(theta) sin(theta);0 -sin(theta) cos(theta)]; %matrix for applying rotation
vertices_rod_rotated = zeros(200,3); %initialising rotated vertices matrix 
for count = 1:2*N
 vertices_rod_rotated(count,:) = (Rtheta*(vertices_rod(count,:)'))';
end
positionMatrix = repmat(position,200,1);
vertices_rod_rotated = vertices_rod_rotated + positionMatrix;
patch('Vertices',vertices_rod_rotated,'Faces',faces_all,'FaceColor',[1 0 0],'LineStyle','none');