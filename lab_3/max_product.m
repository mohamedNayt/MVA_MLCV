function res=max_product(i,E)
    N=neighbors(i,E);
    res = ones(card(i),1);
    for j=N
        res = res.*max_mu(j,i,E);
    end
end