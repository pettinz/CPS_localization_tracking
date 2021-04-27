function [xt, n_iter] = ist(max_iter, tau, A, y, min_eps, lam)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[n, p]=size(A);
xt_0 = zeros(p,1);

for j=1:max_iter
    xt = soft_tresh(xt_0+tau.*(A'*(y-A*xt_0)), lam);
    eps = norm(xt-xt_0,2);
    
    if eps <= min_eps
        break
    end
    xt_0 = xt;
end
n_iter=j;
end

