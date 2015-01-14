function [coordinate_wl,polarity_wl,theta_wl,err_wl] = best_weak_learner2(Distribution_on_indexes,features,labels)
    [nfeatures,npoints] = size(features);
    err = zeros(npoints,nfeatures, 2);
    polarity = [-1,1];
    inverse_permutation = zeros(1,npoints);
    
    for pol=1:2
        for i=1:nfeatures
            [~,permutation] = sort(features(i,:));
            sorted_labels = labels(permutation);
            sorted_distribution = Distribution_on_indexes(permutation); 
            err(1,i,pol) = sum(sorted_distribution(sorted_labels==-polarity(pol)));
            err(2:end,i,pol) = polarity(pol)*sorted_distribution(1:end-1).*sorted_labels(1:end-1);
            err(:,i,pol) = cumsum(err(:,i,pol));
            inverse_permutation(permutation) = 1:npoints;
            err(:,i,pol) = err(inverse_permutation,i,pol);
        end
    end
    
    [err_wl,min_ind] = min(err(:));
    ind_max = 2*nfeatures*npoints;
    pol_ind = (2*min_ind > ind_max)+1;
    coordinate_wl = ((min_ind - (pol_ind-1)*ind_max/2)>ind_max/4)+1;
    theta_ind = min_ind - (pol_ind-1)*ind_max/2 - (coordinate_wl-1)*ind_max/4;
    polarity_wl = 2*pol_ind-3;
    theta_wl = features(coordinate_wl,theta_ind);
end