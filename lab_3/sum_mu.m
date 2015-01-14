function m=sum_mu(j,i,E)
    N = setdiff(neighbors(j,E),i);
    if isempty(N)
        m=sum(Phi([i,j]),2);
    else
        prod = ones(card(j),1);
        for p=N
            prod = prod.*sum_mu(p,j,E);
        end
        m=Phi([i,j])*prod;
    end
end