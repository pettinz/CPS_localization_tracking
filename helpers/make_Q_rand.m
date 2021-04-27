function Q = make_Q_rand(n,r,x,y)
    
    din=zeros(25,1); %incoming edges for each sensor
    for i=1:n
        din(i)=0;
        for j=1:n
            if norm([x(i), y(i)]-[x(j), y(j)])<=r && i~=j
                din(i)=din(i)+1;
            end
        end
    end

    Q1=eye(n); %%uniform metod
    ep=1/(max(din)+1); %%deve essere minore del massimo

    for i=1:n
        for j=n:-1:i
            if norm([x(i), y(i)]-[x(j), y(j)])<=r && i~=j
                Q1(i ,j)=ep;
                Q1(i, i)=Q1(i, i)-ep;
                Q1(j, i)=ep;
                Q1(j, j)=Q1(j, j)-ep;
            end
        end
    end
    eig1=sort(abs(eig(Q1)),'desc');
    
    Q2=eye(n); %%Metropolis metod
    for i=1:n
        for j=n:-1:i
            if  norm([x(i), y(i)]- [x(j), y(j)])<=r && i~=j
                Q2(i ,j)=1/(1+max(din(i),din(j)));
                Q2(i, i) = Q2(i, i) - Q2(i,j);
                Q2(j, i)=Q2(i,j);
                Q2(j, j)=Q2(j, j)- Q2(j,i);
            end
        end
    end
    eig2=sort(abs(eig(Q2)),'desc');
    
    if(eig1(2)<=eig2(2)) %%take the one with the smaller second largest eig
        Q=Q1;
    else
        Q=Q2;
    end
end