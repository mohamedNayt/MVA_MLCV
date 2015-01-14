function m=max_mu(j,i,E)
    N = setdiff(neighbors(j,E),i);
    if isempty(N)
        m=max(Phi([i,j]),[],2);
    else
        prod = ones(card(j),1);
        for p=N
            prod = prod.*max_mu(p,j,E);
        end
        m=transpose(max(Phi([j,i]).*repmat(prod,[1 card(i)])));
    end
end