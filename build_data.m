clear all
close all
clc
addpath('./helpers');

%% Build map
l_room = 10; 
l = 1;
p = 100;
n = 25; % number of sensors

prompt="Press 0 to use the random topology, Press 1 to use grid topology\n";
in = input(prompt);

% get cell coordinates using a meshgrid
tmpc = .5:10;
[xc,yc] = meshgrid(tmpc,tmpc);

switch (in)
    case 0
        xs=l_room*rand(n, 1);
        ys=l_room*rand(n, 1);
        r=4;
        Q = make_Q_rand(n,r,xs,ys);
    case 1
        Q = make_Q_grid(n);
        % get sensor coordinates using a meshgrid
        tmps = linspace(1,9,5);
        [xs,ys] = meshgrid(tmps,tmps);
end

figure(1)
make_grid(xc,yc,xs,ys,l_room)

%% Build A
Pt = 25;
dev_std = 0.5;
var = 0.5^2;

A = zeros(n,p);
for k = 1:p
    [xm,ym] = get_ref(k,l,p);
    d = vecnorm(([xm,ym]-[xs(:),ys(:)])')';
    
    A(:,k) = get_rss(Pt,dev_std,d);
end

%% check connettivity
G=graph(Q);
figure(2)
plot(G)
eigenvalue=sort(abs(eig(Q)))

save cps_data