function u = mutual_coherence(A)
% computes the mutual coherence a matrix
% Input:  a real or complex matrix with more than one column
% Ouput:  the mutual coherence
%
% Written by Dr. Yoash Levron, Technion, Israel, 2015

[M N] = size(A);
if (N<2)
    disp('error - input contains only one column');
    u=NaN;   beep;    return    
end

% normalize the columns
nn = sqrt(sum(A.*conj(A),1));
if ~all(nn)
    disp('error - input contains a zero column');
    u=NaN;   beep;    return
end
nA = bsxfun(@rdivide,A,nn);  % nA is a matrix with normalized columns

u = max(max(triu(abs((nA')*nA),1)));

end