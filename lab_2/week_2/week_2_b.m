%% Create the training data
nsamples = 500; 
problem  = 'nonlinear';
[features,labels,posterior] = construct_data(nsamples,'train',problem,'plusminus');

%%------------------------------------------------------------------
%% visualize training data and posterior
%%------------------------------------------------------------------
figure,
subplot(1,2,1);
imshow(posterior)
title('P(y=1|X): This is the posterior of  the positive class');
subplot(1,2,2);

pos = find(labels==1);
neg = find(labels~=1);
scatter(features(1,pos),features(2,pos),'r','filled'); hold on,
scatter(features(1,neg),features(2,neg),'b','filled'); 

hold on,axis([0,1,0,1]); axis ij; axis square; legend({'positives','negatives'});
title('These are your training data');

%%------------------------------------------------------------------
%% initialize distribution
%%------------------------------------------------------------------

[nfeatures,npoints] = size(features);
Distribution_on_indexes = ones(1,npoints)/npoints;

Rounds_boosting = 400;
%f = zeros(Rounds_boosting,npoints);
f = zeros(1,npoints);
f_on_grid = 0;
alpha = zeros(1,Rounds_boosting);
coordinates = zeros(1,Rounds_boosting);
polarities = zeros(1,Rounds_boosting);
thetas = zeros(1,Rounds_boosting);
err = zeros(1,Rounds_boosting);
n_err = zeros(1,Rounds_boosting);
%%
tic;
for it = 1:Rounds_boosting,
    
    %%--------------------------------------------------------
    %% Find best weak learner at current round of boosting
    %%--------------------------------------------------------
    [coordinate_wl,polarity_wl,theta_wl,err_wl] = best_weak_learner2(Distribution_on_indexes,features,labels);
    coordinates(it) = coordinate_wl;
    polarities(it) = polarity_wl;
    thetas(it) = theta_wl;
    %%--------------------------------------------------------
    %% estimate alpha
    %%--------------------------------------------------------
    alpha(it) = 0.5*log((1-err_wl)/err_wl);
    
    %%--------------------------------------------------------
    %% update  distribution on inputs 
    %%--------------------------------------------------------
    weak_learner_output = evaluate_stump(features,coordinates(it),polarities(it),thetas(it));
    Distribution_on_indexes = Distribution_on_indexes.*exp(-alpha(it)*(labels.*weak_learner_output));
    Distribution_on_indexes = Distribution_on_indexes/sum(Distribution_on_indexes);
    
    %%--------------------------------------------------------
    %% compute loss of adaboost at current round
    %%--------------------------------------------------------
    f = f + alpha(it)*weak_learner_output;
    err(it) = sum(exp(-labels.*f));
    n_err(it) = sum(sign(f)~=labels);
    
    %% leave as is - it will produce the classifier images for you
    [weak_learner_on_grid] = evaluate_stump_on_grid(0:.02:1,0:.02:1,coordinates(it),polarities(it),thetas(it));

    %%--------------------------------------------------------
    %% add current weak learner's response to overall response
    %%--------------------------------------------------------
    f_on_grid   = f_on_grid + alpha(it).*weak_learner_on_grid;
    switch it
        case 10,
            f_10 = f_on_grid;
        case 50,
            f_50 = f_on_grid;
        case 100
            f_100 = f_on_grid;
    end
    
end
toc;
misclassification_error_train = mean(sign(f)~=labels);
%misclassification_error_train = 0.114
%%
figure,
plot(err),hold on
plot(n_err,'r');
legend({'Adaboost loss','Number of errors'});
print('-depsc','loss_adaboost')

figure
subplot(1,2,1);
imshow(posterior);
subplot(1,2,2);
imshow(1./(1+exp(-2*f_on_grid)))

print('-depsc','classifiers')

figure
subplot(1,4,1);
imshow(f_10,[-1,1]); title('strong learner - round 10')
subplot(1,4,2);
imshow(f_50,[-1,1]); title('strong learner - round 50')
subplot(1,4,3);
imshow(f_100,[-1,1]); title('strong learner - round 100')
subplot(1,4,4);
imshow(f_on_grid,[-1,1]); title('strong learner - round 400')
print('-depsc','per_round')

%%
% Performance on test set
%%
[test_features,test_labels] = construct_data(nsamples,'test',problem,'plusminus');
f_test = zeros(1,nsamples);
for i=1:Rounds_boosting
    weak_learner_output_test = evaluate_stump(test_features,coordinates(it),polarities(it),thetas(it));
    f_test = f_test + alpha(it)*weak_learner_output_test;
end
test_predicted_labels = sign(f_test);
misclassification_error = mean(test_predicted_labels ~= test_labels);
%=0.298