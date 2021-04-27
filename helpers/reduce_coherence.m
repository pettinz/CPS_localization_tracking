function [is_lower,Om,pseudo] = reduce_coherence(A)
%REDUCE_COHERENCE Summary of this function goes here
%   Detailed explanation goes here

before = mutual_coherence(A);
Om = (orth(A'))';
after = mutual_coherence(Om);

is_lower = after < before;

pseudo = A'/(A*A');

end

