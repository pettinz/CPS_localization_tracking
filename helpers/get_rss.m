function [RSS] = get_RSS_v2(Pt,dev_std,d)
% RSS(d) =
%   Pt - 40.2 - 20log(d) + n,   if d <= 8
%   Pt - 58.5 - 33log(d) + n,   if d > 8

RSS = (d<=8).*(Pt-40.2-20.*log10(d)+dev_std*randn()) + (1-(d<=8)).*(Pt-58.5-33.*log10(d)+dev_std*randn());

end