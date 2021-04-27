function [nn, sn, xn, yn] = get_neighbors(k,n)
%get_neighbors returns the TOP, LEFT, BOTTOM, RIGHT neighbors of element k 
% in a grid topology distribution of n elements.
%
% Input:
%   k : The current item
%   n : The number of items
%
% Output:
%   nn : A vector of neighbors
%   sn : The number of neighbors
%   xn : The x coordinates of the neighbors
%   yn : The y coordinates of the neighbors

%     arguments
%         k (1,1) double {mustBeInteger}
%         n (1,1) double {mustBeInteger}
%     end
    
    n = sqrt(n);
    
    j = mod(k-1, n) + 1;
    i = fix((k-1) / n) + 1;
    
    xv = [1 n n 1 1];
    yv = [1 1 n n 1];
    
    xn_t = [i-1 i i+1 i];
    yn_t = [j j+1 j j-1];
    
    in = inpolygon(xn_t,yn_t,xv,yv);
    
    xn = xn_t(in);
    yn = yn_t(in);
    
    if length(xn) ~= length(yn)
        throw(MException('get_neighbors:length', 'Lengths do not match'))
    end
    
    sn = length(xn);
    
    nn = zeros(sn,1);
    for k = 1:sn
        i = xn(k);
        j = yn(k);
        nn(k) = (i-1)*5+mod(j-1,5)+1;
    end
end