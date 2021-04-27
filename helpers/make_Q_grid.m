function Q = make_Q_grid(n)
    Q1 = make_Q_grid_uniform(n);
    Q2 = make_Q_grid_metropolis(n);
    
    l1 = sort(eig(Q1), "descend");
    l2 = sort(eig(Q2), "descend");
    
    if l1(2) < l2(2)
        Q = Q1;
    else
        Q = Q2;
    end
end