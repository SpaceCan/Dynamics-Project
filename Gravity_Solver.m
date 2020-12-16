%% Setting up parameters
clear;clc;close all
global G m nObjects;

% Dialog box for simulations
tf=1;
while tf==1
    %menu text list
    list = {'Earth and Moon Simulation', 'Inner Planet Solar System Simulation', 'Figure 8 System Simulation', 'Random Simulation'};
    %display the dialog box
    %cancel or <esc> closes the dialog
    [indx,tf] = listdlg('ListString',list, 'Name','Dynamics Final Project','PromptString',{'Please select a scenario:'},'ListSize',[350,100],'SelectionMode','single');
    Nindx=numel(indx);
    
    for iindx=1:Nindx
    %Execute selected option
    iopt=indx(iindx);
    switch iopt
        case 1
            load('Earth_Moon.mat')
            tf=0;
        case 2
            load('Inner_Planets.mat')
            tf=0;
        case 3
            load('Figure_8.mat')
            tf=0;
        case 4
            load('Random.mat')
            tf=0;
        otherwise
    end
    end
end

G = 6.674*10^-11;
y0 = [r,rdot];
t = 0:dt:t_f;
nObjects = round(length(r)/3);
%% Setting up spacial plot
fig = figure('Color',[0.08 0.08 0.08],'Units','normalized','InnerPosition',[0.25/2 0.25/2 0.75 0.75]);
%fig = figure('Color',[0.08 0.08 0.08],'Units','inches','InnerPosition',[2 1 6.5 3.65]);
set(fig, 'InvertHardCopy', 'off');
% Trail graphics object
trl = quiver3(r(((1:nObjects)-1)*3+1),...
              r(((1:nObjects)-1)*3+2),...
              r(((1:nObjects)-1)*3+3),...
       dt.*rdot(((1:nObjects)-1)*3+1),...
       dt.*rdot(((1:nObjects)-1)*3+2),...
       dt.*rdot(((1:nObjects)-1)*3+3),0);
trl.ShowArrowHead = 'off';
hold on
% Planetary graphics object
s = scatter3(r(((1:nObjects)-1)*3+1),...
             r(((1:nObjects)-1)*3+2),...
             r(((1:nObjects)-1)*3+3),pointScale,colors./256,'filled');

% Axis Definitions
ax = gca;
axis equal
ax.Clipping = 'off';
ax.Box = 'off';
axis(limits)
ax.Color = [0.08 0.08 0.08];
ax.GridColor = [1 1 1];
ax.XColor = [0.9 0.9 0.9];
ax.XAxis.LineWidth = 0.75;
ax.YColor = [0.9 0.9 0.9];
ax.YAxis.LineWidth = 0.75;
ax.ZColor = [0.9 0.9 0.9];
ax.ZAxis.LineWidth = 0.75;
camproj('perspective')
cameratoolbar('SetMode','orbit')
campos(camStart)
camtarget('manual')
camva(30)
time = annotation('textbox','Color',[1 1 1],'LineStyle','none','FontSize',16);
time.Position = [0.05 0.75 0.2 0.2];
%% Simulation
sol = leapfrog_solve(@a_func, y0, t);
currentTime = now;
%camtarget(sol(1,1:3))
%% Animation
% change array range to adjust what timeframe the animation plays over
for i = 2:length(t)-1
    % Update trail using position data since start of simulation
    trl.XData = sol(2:i, ((1:nObjects)-1)*3+1);
    trl.YData = sol(2:i, ((1:nObjects)-1)*3+2);
    trl.ZData = sol(2:i, ((1:nObjects)-1)*3+3);
    
    % Update trail using difference in position
    trl.UData = -(sol(2:i, ((1:nObjects)-1)*3+1) - sol((2:i)-1, ((1:nObjects)-1)*3+1));
    trl.VData = -(sol(2:i, ((1:nObjects)-1)*3+2) - sol((2:i)-1, ((1:nObjects)-1)*3+2));
    trl.WData = -(sol(2:i, ((1:nObjects)-1)*3+3) - sol((2:i)-1, ((1:nObjects)-1)*3+3));
    
    % Update bodies using current position
    s.XData = sol(i,((1:nObjects)-1)*3+1);
    s.YData = sol(i,((1:nObjects)-1)*3+2);
    s.ZData = sol(i,((1:nObjects)-1)*3+3);
    
    % Display time in sim in relation to current time
    time.String = datestr(seconds(t(i)),'HH:MM:SS.FFF mm-dd-yyyy');
    %dx = (sol(i,1)-sol(i-1,1));
    %dy = (sol(i,2)-sol(i-1,2));
    %dz = (sol(i,3)-sol(i-1,3));
    %camdolly(dx,dy,dz,'movetarget','data')
    drawnow
end
%print('Random','-djpeg','-r300');
%% Plotting absolute velocity
figure('Color',[0.08 0.08 0.08],'Units','inches','InnerPosition',[2 1 6.5 3.65])
set(gcf, 'InvertHardCopy', 'off');
switch iopt
    case 1
        bodies = ["Earth","Moon"];
        lineType = ["-","-","-"];
    case 2
        bodies = ["Sun","Mercury","Venus","Earth","Mars","Rogue Star"];
        lineType = ["-","-","-","-","-","--"];
    case 3
        bodies = ["1","2","3"];
        lineType = ["-","--","-."];
    case 4
        bodies = ["1","2","3","4","5"];
        lineType = ["-","-","-","-","-"];
    otherwise
        bodies = [];
end
hold on
for obj = 1:nObjects
    plot(datetime(0000,1,1)+seconds(t),...
        vecnorm(sol(:,((obj-1)*3+1:obj*3)+nObjects*3),2,2),...
        'Color',colors(obj,:)/256,'LineWidth',1.5,'DisplayName',bodies(obj),'LineStyle',lineType(obj))
end
legend('Color',[0.08 0.08 0.08],'TextColor',[1 1 1])
ax = gca;
ax.Color = [0.08 0.08 0.08];
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridColor = [1 1 1];
ax.XColor = [0.9 0.9 0.9];
ax.XAxis.LineWidth = 0.75;
ax.YColor = [0.9 0.9 0.9];
ax.YAxis.LineWidth = 0.75;
ax.ZColor = [0.9 0.9 0.9];
ax.ZAxis.LineWidth = 0.75;
xlabel('Time (MATLAB Datetime)')
ylabel('Absolute Velocity [m/s]')
print('Velocity-plot','-djpeg','-r300');
%% acceleration function
function [ydot] = a_func(t, y)
% Given vector y, output its derivative (velocity and acceleration in this case)
global G m nObjects;
r = y(1:nObjects*3);
rdot = y(nObjects*3+1:end);
r2dot = zeros(1,length(r));
% defines a vector of object indicies
obj = 1:nObjects;
% Loop through each object 
for i = obj
    for j = obj(obj ~= i)
        r2dot((i-1)*3+1:i*3) = r2dot((i-1)*3+1:i*3) + (G*m(j).*(r((j-1)*3+1:j*3)-r((i-1)*3+1:i*3)))...
            /(norm(r((j-1)*3+1:j*3)-r((i-1)*3+1:i*3))^3);
    end
end

ydot = [rdot r2dot];
end
%% Leapfrog Solver function
function [sol] = leapfrog_solve(ydot, init, t)
% The following uses leapfrog integration to find position
% Inputs:
% ydot - function for finding acceleration at a given time and y
% init - initial conditions for the system
% t    - vector containing all the times t that we wish to solve
global nObjects;
sol = zeros(length(t),nObjects*6);
obj = 1:nObjects*3;
% The sol matrix stores positions and velocities for every timestep
sol(1,:) = init;
for i = 1:length(t)-1
    step = t(i+1) - t(i);
    % Find next position using current velocity and acceleration
    ydot1 = ydot(t(i), sol(i,:));
    sol(i+1,obj) = sol(i,obj) + step * sol(i,obj+max(obj))...
        + (step^2)/2 * ydot1(obj+max(obj));
    % Find next velocity using current acceleration and next acceleration
    ydot2 = ydot(t(i+1), sol(i+1,:));
    sol(i+1,obj+max(obj)) = sol(i,obj+max(obj)) +...
    step * (ydot1(obj+max(obj)) + ydot2(obj+max(obj)))/2;
end
end