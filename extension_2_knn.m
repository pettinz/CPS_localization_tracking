%% Additional point localization part: comparing with KNN
clear all
close all
clc

load cps_data

figure(1)
make_grid(xc,yc,xs,ys,l_room)
%% runtime phase
figure(1), hold on

ni=50;
[c_is_lower,Om,Apseudo] = reduce_coherence(A);
success = 0;
dist=zeros(ni, 1);
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
    
    
    p_cell = knnsearch(Ap',yp','dist','euclidean','k',1);
    
    % if(m>1)
    %     d = +inf;
    %     p_cell = -1;
    %     for j = 1 : p
    %         argum = 0;
    %         for i = 1 : n
    %             argum = argum + (norm(y((i-1)*m+1 :(i-1)*m+m,1)-A((i-1)*m+1:(i-1)*m+m,j)));
    %         end
    %         if argum < d
    %             p_cell = j-1; %j-1 così è già sistemato (non faccio p_cell-1)
    %             d = argum;
    %         end
    %     end
    % end
    
    [xe,ye] = get_ref(p_cell,l,p);  % position from estimated cell
    p2 = scatter(xe, ye,'filled','MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5,'DisplayName','Estimated');
    dist(it)= norm([xe ye] - [xm ym]);
    
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

figure()
plot([1:ni], dist, '--*')
xlabel('iteration')
ylabel('distance(m)')
title(['K-NN - Success rate = ', num2str(success/ni*100), '%'])