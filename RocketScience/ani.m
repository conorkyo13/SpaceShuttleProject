function myfilm = ani(height,range,n)
% ani(height,range,number of points)
% 3d animation for the trajectory of the space shuttle
% 
% v 2.0


Y = zeros(1,n+1); % no y data

fig = figure('Position',[100 100 850 600]) % postion figure

plothandle = plot3(range,Y,height,'.','EraseMode','none');
axis([0 5.5e6 -2 2 0 4e5])
xlabel('range [f]','color',[0 0 1])
zlabel('height [f]','color',[0 0 1])
title('Trajectory of Space Shuttle','color',[0 0 1])
hold on

view(-137,30)

for count = 1:100:n % in steps of 100 so it doesn't take that long to make
       
    set(plothandle,'XData',range(1:count),'YData',Y(1:count),'ZData',height(1:count))
    drawnow 
    myfilm((count-1)/100+1) = getframe(fig);
      
end

movie(myfilm)