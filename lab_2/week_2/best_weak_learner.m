function [coordinate_wl,polarity_wl,theta_wl,err_wl] = best_weak_learner(Distribution_on_indexes,features,labels)
    [nfeatures,npoints] = size(features);
    err = zeros(npoints,nfeatures, 2);
    polarity = [-1,1];
    
    for pol=1:2
        for i=1:nfeatures
            for j=1:npoints
                weak_leanrner_output = evaluate_stump(features, i, polarity(pol), features(i,j));
                err(j,i,pol) = sum((labels ~= weak_leanrner_output).*Distribution_on_indexes);
            end
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