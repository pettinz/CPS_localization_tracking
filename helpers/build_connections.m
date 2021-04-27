function P = build_connections(n)
%build_connections connects elements deployed on a grid.
% Elements are connected to 4 closest elements (3 or 2 on the boundaries)
%
% Input:
%   n : The number of elements
%
% Output:
%   P : A matrix m-by-m (m=sqrt(n)) representing the element in the grid
%       topology. Each cell contains the number of links.

%     arguments
%         n (1,1) double {mustBeInteger}
%     end
    
    xq = zeros(n,1);
    yq = zeros(n,1);
    
    n = sqrt(n);
    
    xv = [1 n n 1 1];
    yv = [1 1 n n 1];
    
    k = 1;
    for i = 1:n
        for j = 1:n
            xq(k) = i;
            yq(k) = j;
            k = k+1;
        end
    end
    
    P = ones(n).*double(GridPos.Inner);
    [~,on] = inpolygon(xq,yq,xv,yv);
    xq = xq(on);
    yq = yq(on);
    
    if length(xq) ~= length(yq)
        throw(MException('build_connections:length', 'Lengths do not match'))
    end
    
    for k = 1:length(xq)
        i = xq(k);
        j = yq(k);
        
        P(i,j) = double(GridPos.Border);
        for z = 1:4
            if xv(z) == i && yv(z) == j
                P(i,j) = double(GridPos.Corner);
                break;
            end
        end
    end
end