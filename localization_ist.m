clear all
close all
clc

load cps_data

figure(1)
make_grid(xc,yc,xs,ys,l_room)
%% IST
figure(1), hold on

ni=50; %%number of iterations
lam = 1e-4;
tau = 0.7;
th = 0.5;
max_iter = 1e4;
min_eps = 1e-5;
success = 0;
iter=zeros(ni, 1);
dist=zeros(ni, 1);

[c_is_lower,Om,Apseudo] = reduce_coherence(A);
cell=randperm(p, ni);

for i=1:ni    
    [xm,ym] = get_ref(cell(i),l,p);  % position from measured cell
    
    p1 = plot(xm,ym,'sb','MarkerSize',10, 'DisplayName','Target');
        
    d = vecnorm(([xm,ym]-[xs(:),ys(:)])')';
    y = get_rss(Pt,dev_std,d);
    
    if c_is_lower
        yp=Om*Apseudo*y;
        Ap=Om;
    else
        yp=y;
        Ap=A;
    end
    
    [xt, iter(i)]=ist(max_iter, tau, Ap, yp, min_eps, lam);
    
    [~, p_cell] = max(abs(xt));
    [xe,ye] = get_ref(p_cell,l,p);  % position from estimated cell
    dist(i)= norm([xe ye] - [xm ym]);
    p2 = scatter(xe, ye,'filled','MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5,'DisplayName','Estimated');

    if cell(i)==p_cell
        fprintf('Success\n');
        success=success+1;
    else
        fprintf('Fail\n');
    end
    fprintf('Cella: %d, Predetta: %d\n', cell(i), p_cell);
    pause()
    delete(p1)
    delete(p2)
end
fprintf('\n\nSuccess rate: %2.0f%%\nAverage number of iterations: %d\n',...
    (success/ni*100), round(mean(iter)));
figure()
plot([1:ni], dist, '--*')
xlabel('iteration')
ylabel('distance(m)')
title('IST')
xlim([1 50])

figure()
plot([1:ni], iter, '--*')
hold on 
plot([1 ni], [mean(iter) mean(iter)], '--r')
xlabel('iteration')
ylabel('number of iterations')
title('IST')
ylim([min(iter) max(iter)])
xlim([1 50])
legend('number of iterations', 'average number of iterations', 'Location', 'southwest')
legend('boxoff')
