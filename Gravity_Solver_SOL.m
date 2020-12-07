%% Setting up parameters
clear;clc
global G m nObjects;
G = 6.674*10^-11;
dt = 86400*2;
t = 0:dt:2.208e+8;
load('Inner_Planets.mat');
y0 = [r rdot];
nObjects = round(length(r)/3);
%% Setting up spacial plot
fig = figure('Color',[0.08 0.08 0.08],'Units','normalized','InnerPosition',[0.25/2 0.25/2 0.75 0.75]);

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
             r(((1:nObjects)-1)*3+3),log1p(m/min(m)).*200,colors./256,'.');

% Axis Definitions
ax = gca;
axis equal
ax.Clipping = 'off';
ax.Box = 'off';
axis([-1.496e+11 1.496e+11 -1.496e+11 1.496e+11 -1.496e+11 1.496e+11])
ax.Color = [0.08 0.08 0.08];
ax.GridColor = [1 1 1];
ax.XColor = [0.9 0.9 0.9];
ax.XAxis.LineWidth = 0.75;
ax.YColor = [0.9 0.9 0.9];
ax.YAxis.LineWidth = 0.75;
ax.ZColor = [0.9 0.9 0.9];
ax.ZAxis.LineWidth = 0.75;
ax.YRuler.FirstCrossoverValue = 0;
ax.XRuler.FirstCrossoverValue = 0;
ax.ZRuler.FirstCrossoverValue = 0;
ax.ZRuler.SecondCrossoverValue = 0;
ax.XRuler.SecondCrossoverValue = 0; % X crossover with Z axis
ax.YRuler.SecondCrossoverValue = 0;
camproj('perspective')
cameratoolbar('SetMode','orbit')
campos([1.496e+11*2.5 1.496e+11*2.5 1.496e+11*2.5])
camva(30)
%% Simulation
sol = leapfrog_solve(@a_func, y0, t);

%% Animation
tic
for i = 2:length(t)
    
    trl.XData = sol(2:i, ((1:nObjects)-1)*3+1);
    trl.YData = sol(2:i, ((1:nObjects)-1)*3+2);
    trl.ZData = sol(2:i, ((1:nObjects)-1)*3+3);
    
    trl.UData = -(sol(2:i, ((1:nObjects)-1)*3+1) - sol((2:i)-1, ((1:nObjects)-1)*3+1));
    trl.VData = -(sol(2:i, ((1:nObjects)-1)*3+2) - sol((2:i)-1, ((1:nObjects)-1)*3+2));
    trl.WData = -(sol(2:i, ((1:nObjects)-1)*3+3) - sol((2:i)-1, ((1:nObjects)-1)*3+3));
    
    s.XData = sol(i,((1:nObjects)-1)*3+1);
    s.YData = sol(i,((1:nObjects)-1)*3+2);
    s.ZData = sol(i,((1:nObjects)-1)*3+3);
    calcTime=toc;
    drawnow
    %pause(max(dt-calcTime,0))
    tic
end
%% acceleration function
function [ydot] = a_func(t, y)
% Given vector y, output its derivative (velocity and acceleration in this case)
global G m nObjects;
r = y(1:nObjects*3);
rdot = y(nObjects*3+1:end);
r2dot = zeros(1,length(r));
% defines a vector of object indicies
obj = 1:nObjects;
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