function [centers,distortion]=kmeans(data,k,niter)
    nruns=20;
    distortions=zeros(niter,nruns);
    n=size(data,1);
    centers = zeros(nruns*k,2);
    for i=1:nruns
        centers((k*(i-1)+1):k*i,:) = data(randi(n,[1 k]),:);
        for j=1:niter
            dist = zeros(k,n);
            for s=1:k
                for t=1:n
                    dist(s,t) = norm(data(t,:)-centers(k*(i-1)+s,:));
                end
            end
            [min_dist,point_center] = min(dist);
            distortions(j,i) = sum(min_dist);
            for p=1:k
                centers(k*(i-1)+p,:) = mean(data(point_center==p,:));
            end
        end
    end
    [~,ind]=min(distortions(niter,:));
    distortion = distortions(:,ind);
    centers = centers((k*(ind-1)+1):k*ind,:);
end