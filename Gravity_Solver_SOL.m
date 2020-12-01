%% Setting up parameters
clear;clc
G = 6.674*10^-11;
load('Inner_Planets.mat');
%% Setting up spacial plot
trl = quiver3(r(:,1),r(:,2),r(:,3),...
    dt.*rdot(:,1),dt.*rdot(:,2),dt.*rdot(:,3),0);
hold on
s = scatter3(r(:,1),r(:,2),r(:,3),50,'filled');
trl.ShowArrowHead = 'off';

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
