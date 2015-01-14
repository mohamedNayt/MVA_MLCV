function res=sum_product(i,E)
    N=neighbors(i,E);
    res = ones(card(i),1);
    for j=N
        res = res.*sum_mu(j,i,E);
    end
end