%% Setting up parameters
clear;clc
G = 6.674*10^-11;
n = 10;
spread = 5;
%G = 1;
dt = 100000;
% Initial masses
% m_1 = 1/G;
% m_2 = 1/G;
% m_3 = 1/G;
m_0 = 1.989e+30;
m_1 = 0.33011e+24;
m_2 = 4.86750e+24;
m_3 = 5.97219e+24;
m_4 = 0.64171e+24;
m_b = 1.989e+30;
m = [m_0;m_1;m_2;m_3;m_4;m_b];
%m = (exp(rand(n,1).*3)).*1/G;
% Initial Positions
% r_1 = [0.97000436 -0.24308753 0];
% r_2 = -r_1;
% r_3 = [0 0 0];
r_0 = [0 0 0];
r_1 = [-46.002e+9 0 0];
r_2 = [-107.476e+9 0 0];
r_3 = [-147.092e+9 0 0];
r_4 = [-206.617e+9 0 0];
r_b = [0.5*-147.092e+9 0.5*-147.092e+9 30*147.092e+9];
r = [r_0;r_1;r_2;r_3;r_4;r_b];
%r = rand(n,3).*spread-spread/2;
% Initial Velocities
% rdot_1 = [0.93240737/2 0.86473146/2 0];
% rdot_2 = [0.93240737/2 0.86473146/2 0];
% rdot_3 = [-0.93240737 -0.86473146 0];
rdot_0 = [0 0 0];
rdot_1 = [0 58980 0];
rdot_2 = [0 35260 0];
rdot_3 = [0 30290 0];
rdot_4 = [0 26500 0];
rdot_b = [0 0 -58980];
rdot = [rdot_0;rdot_1;rdot_2;rdot_3;rdot_4;rdot_b];
%rdot = rand(n,3).*2-1;
%% Setting up spacial plot
trl = quiver3(r(:,1),r(:,2),r(:,3),...
    dt.*rdot(:,1),dt.*rdot(:,2),dt.*rdot(:,3),0);
hold on
s = scatter3(r(:,1),r(:,2),r(:,3),50,'filled');
trl.ShowArrowHead = 'off';
%trl.LineStyle = 'none';
%trl.Marker = '.';
%trl.MarkerSize = 5;

ax = gca;
axis equal
ax.Clipping = 'off';
ax.Box = 'off';
axis([-1.496e+11 1.496e+11 -1.496e+11 1.496e+11 -1.496e+11 1.496e+11])
camproj('perspective')
cameratoolbar('SetMode','orbit')
%% Simulation Loop
rold = r;
rdotold = rdot;
tic
while true
    r2dot = zeros(size(r,1),size(r,2));
    for i = 1:size(r,1)
        for j = 1:size(r,1)
            if j == i
            else
                r2dot(i,:) = r2dot(i,:) + (G*m(j).*(r(j,:)-r(i,:)))/(norm(r(j,:)-r(i,:))^3);
            end
        end
    end
    rdot = rdot + dt.*r2dot;
    r = r + dt.*rdot;
    %mold = cat(1,mold,m);
    
    rold = cat(1,rold,r);
    rdotold = cat(1,rdotold,rdot);
    if(size(rold,1) > size(r,1)*round(11000000/dt))
        rold = rold((end-size(r,1)*round(11000000/dt)):end,:);
        rdotold = rdotold((end-size(r,1)*round(11000000/dt)):end,:);
    end
%    rold(ones(size(rold,1),size(rold,2)).*(1:size(rold,1))' + round(1/dt) < 0) = [];
%    rdotold(ones(size(rold,1),size(rold,2)).*(1:size(rold,1))' + round(1/dt) < 0) = [];
    trl.XData = rold(:,1);
    trl.YData = rold(:,2);
    trl.ZData = rold(:,3);
    
    trl.UData = -dt.*rdotold(:,1);
    trl.VData = -dt.*rdotold(:,2);
    trl.WData = -dt.*rdotold(:,3);
    
    s.XData = r(:,1);
    s.YData = r(:,2);
    s.ZData = r(:,3);
    calcTime=toc;
    drawnow
    %pause(max(dt-calcTime,0))
    tic
end
