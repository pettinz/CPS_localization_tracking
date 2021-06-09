clear all
close all
clc

load cps_data

figure(1)
make_grid(xc,yc,xs,ys,l_room)
%% IST
figure(1), hold on

ni=50;
lam = 1e-4;
tau = 0.7;
th = 0.5;
max_iter = 1e5;
dist=zeros(ni, 1);
success_brok=0;
success=0;

for i=1:50
    cell=randperm(p, 1);
    broken_sensor=randperm(n, 2)-1;
    
    %target
    [xm,ym] = get_ref(cell,l,p);  % position from measured cell
    xbroken=xs(1, fix(broken_sensor/5)+1);
    ybroken=ys(mod(broken_sensor, 5)+1, 1);
    
    p1 = plot(xm,ym,'sb','MarkerSize',10, 'DisplayName','Target');
    p2 = scatter(xbroken, ybroken,'r', 'filled','DisplayName','Broken Sensor');
    
    d = vecnorm(([xm,ym]-[xs(:),ys(:)])')';
    y = get_rss(Pt,dev_std,d);
    y(broken_sensor+1)=y(broken_sensor+1)+100*rand(1);
    
    B=[A, eye(n)];
    u=zeros(n, 1);
    
    [c_is_lower,Om,Bpseudo] = reduce_coherence(B);
    
    if c_is_lower
        yp=Om*Bpseudo*y;
        Bp=Om;
    else
        yp=y;
        Bp=B;
    end
    
    xt_0 = zeros(p,1);
    
    zt_0=[xt_0; u];
    
    for j=1:max_iter
        zt = soft_tresh(zt_0+tau.*(Bp'*(yp-Bp*zt_0)), lam);        
        xt=zt(1:p);
        u=zt(p+1:end);
        xt(find(xt>1))=1;
        xt(find(xt<0))=0;
        zt_0=[xt;u];
    end

    [~, p_cell] = max(xt);
    [~, p_broken(1)] = max(abs(u));
    u(p_broken(1))=0;
    [~, p_broken(2)] = max(abs(u));
        
    [xe,ye] = get_ref(p_cell,l,p);
    dist(i)= norm([xe ye] - [xm ym]);
    p3 = scatter(xe, ye,'filled','MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5,'DisplayName','Estimated');
    
    if cell==p_cell
        fprintf('Success\n');
        success=success+1;
    else
        fprintf('Fail\n');
    end

    
    fprintf('Cella: %d, Predetta: %d\n', cell, p_cell);
    broken_sensor=sort(broken_sensor);
    p_broken=sort(p_broken);
    
    if broken_sensor+1==p_broken
        success_brok=success_brok+1;
    end
    
    fprintf('Broken: %d %d, Predict: %d %d\n', broken_sensor(1)+1, broken_sensor(2)+1, p_broken(1), p_broken(2));
    
    %pause()
    delete(p1)
    delete(p2)
    delete(p3)
end

figure()
plot([1:ni], dist, '--*')
xlabel('iteration')
ylabel('distance(m)')
title(['IST broken sensors - Success rate = ', num2str(success/ni*100), '% ', 'Success broken = ', num2str(success_brok/ni*100), '%'])
xlim([1 50])