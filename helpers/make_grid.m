function make_grid(xc,yc,xs,ys,size)
%MAKE_GRID Summary of this function goes here
%   Detailed explanation goes here
    scatter(xs(:),ys(:),'filled','DisplayName','Sensors'), grid on, hold on
    % scatter(xc(:),yc(:),'filled','DisplayName','Positions'), hold off
    xticks(0:1:size)
    yticks(0:1:size)
    xlim([0 size])
    ylim([0 size])
    
    title("Room grid")
    legend('Location', 'northeastoutside')
end

