clear all
close all
clc

load cps_data

figure(1)
make_grid(xc,yc,xs,ys,l_room)

%% O-DIST-moving_diagonal
figure(1), hold on

lam = 1e-4;
tau = 0.7;
max_iter = 1e2;
min_eps = 1e-4;
success = 0;

ni = l_room;
dist=zeros(l_room,1);

[c_is_lower,Om,Apseudo] = reduce_coherence(A);
xt_0 = zeros(p,n);

for it = 1:ni
    c = (it-1)*l_room+it;
    [xm,ym] = get_ref(c,l,p);  % position from measured cell
    
    p1 = plot(xm,ym,'sb','MarkerSize',10, 'DisplayName','Target');
    
    % RSS computation
    d = vecnorm(([xm,ym]-[xs(:),ys(:)])')';
    y = get_rss(Pt,dev_std,d);
    
    if c_is_lower
        yp=Om*Apseudo*y;
        Ap=Om;
    else
        yp=y;
        Ap=A;
    end
    
    [xt, iter]=distt(Ap, yp, xt_0, max_iter, Q, tau, lam, min_eps); 
    xt_0=xt;
    
    [~, ce] = max(abs(xt)); % estimated cell
    [xe,ye] = get_ref(ce,l,p);  % position from estimated cell
    p2 = scatter(xe, ye,'filled','MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5, 'DisplayName','Estimated');
    
    dist(it)= norm([mean(xe),mean(ye)] - [xm,ym]);
 
    if sum(ce == c) > n/2
        fprintf('Success\nnum iter: %d\n', iter);
        success = success+1;
    else
        fprintf('Fail\nnum iter: %d\n', iter);
    end
    fprintf('Position: %d, Estimation: %d\n', c, mode(ce));
    
    pause()
    delete(p1), delete(p2)
end

cum_dist = cumsum(dist);
fprintf('\n\nSuccess rate: %2.0f%%\n', (success/ni*100))

figure()
plot([1:ni], dist, '--*')
xlabel('iteration')
ylabel('distance(m)')
title(['O-DIST - Succes rate = ', num2str(success/ni*100), '%'])

figure()
plot([1:ni], cum_dist, '--*')
xlabel('iteration')
ylabel('cumulative distance(m)')
title('O-DIST')