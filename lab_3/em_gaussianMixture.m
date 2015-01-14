function [means,covs,p,likelihood]=em_gaussianMixture(data,means,covs,p,niter)

    [n,dim]=size(data);
    k = size(means,1);
    resp = zeros(n,k);
    likelihood = zeros(1,niter);
    
    for i=1:niter
        % E step
        for j=1:k
            resp(:,j) = p(j)*mvnpdf(data,means(j,:),covs(:,:,j));
        end
       resp = resp./repmat(sum(resp,2),[1 k]);
       % M step
       p = mean(resp);
       resp = resp./repmat(sum(resp),[n 1]);
       means = transpose(resp)*data;
       for h=1:k
            covs(:,:,h)=transpose(repmat(resp(:,h),[1 2]).*(data-repmat(means(h,:),[n 1])))*(data-repmat(means(h,:),[n 1]));
            likelihood(i)=likelihood(i)+p(h)*sum(mvnpdf(data,means(h,:),covs(:,:,h)));
       end
      
    end
    
end