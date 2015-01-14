function post=bayes_posterior(x,means,covs,p)
    k=size(means,1);
    n=size(x,1);
    score=zeros(n,k);
    
    for i=1:k
        score(:,i) = p(i)*mvnpdf(x,means(i,:),covs(:,:,i));
    end
    [~,post] = max(score,[],2);
end