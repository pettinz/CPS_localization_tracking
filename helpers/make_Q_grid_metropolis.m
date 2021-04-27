function Q = make_Q_grid_metropolis(n)
%     arguments
%         n (1,1) double {mustBeInteger}
%     end
    
    P = build_connections(n);
    P = reshape(P,1,[]);
    
    Q = zeros(n);
    for i = 1:n
        [nn, sn] = get_neighbors(i, n);
        k = 1;
        for j = 1:sn
            d = 1/(1+max(P(i),P(nn(j))));
            k = k-d;
            Q(i,nn(j)) = d;
        end
        Q(i,i) = k;
    end
end