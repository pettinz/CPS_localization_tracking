clear all
close all
clc

load cps_data

figure(1)
make_grid(xc,yc,xs,ys,l_room)
%% DIST
figure(1), hold on
ni=50;
lam = 1e-4;
tau = 0.7;
max_iter = 1e4;
min_eps = 1e-6;
success = 0;
iter=zeros(ni,1);
dist=zeros(ni, 1);

[c_is_lower,Om,Apseudo] = reduce_coherence(A);
cell=randperm(p, ni);

for it=1:ni
    [xm,ym] = get_ref(cell(it),l,p);  % position from measured cell
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
    
    xt_0 = rand(p,n);
    [xt, iter(it)]=distt(Ap, yp, xt_0, max_iter, Q, tau, lam, min_eps); 
    %round(xt,2) %% see if consensus
    
   [~, p_cell] = max(abs(xt));
   [xe,ye] = get_ref(p_cell,l,p);  % position from estimated cell
   p2 = scatter(xe, ye,'filled','MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5,'DisplayName','Estimated');
   dist(it)= norm([mode(xe) mode(ye)] - [xm ym]);
 
    if cell(it)==mode(p_cell)
        fprintf('Success\n');
        success=success+1;
    else
        fprintf('Fail\n');
    end
    fprintf('Cella: %d, Predetta: %d\n', cell(it), mode(p_cell));
    %pause()
    delete(p1)
    delete(p2)
end
fprintf('\n\nSuccess rate: %2.0f%%\nAverage number of iterations: %d\n',...
    (success/ni*100), round(mean(iter)));
figure()
plot([1:ni], dist, '--*')
xlabel('iteration')
ylabel('distance(m)')
title(['DIST - Success rate = ', num2str(success/ni*100), '%'])
%pause()

figure()
plot([1:ni], iter, '--*')
hold on 
plot([1 ni], [mean(iter) mean(iter)], '--r')
xlabel('iteration')
ylabel('number of iterations')
title(['DIST - Avg number of iterations = ', num2str(mean(iter))])
ylim([min(iter) max(iter)])
xlim([1 50])
legend('number of iterations', 'average number of iterations', 'Location', 'southwest')
legend('boxoff')