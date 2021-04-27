function [res] = soft_tresh(x, lam)
res = (x-lam.*sign(x)).*(abs(x)>lam);
end

