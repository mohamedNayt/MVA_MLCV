%% Create the training data
nsamples = 500; 
problem  = 'nonlinear';
[features,labels] = construct_data(nsamples,'train',problem,'plusminus');
[ndimensions,ndata]  = size(features);

%% display your data
pos = find(labels==1);
neg = find(labels~=1);

hf = figure;
scatter(features(1,pos),features(2,pos),'r','filled'); hold on,
scatter(features(1,neg),features(2,neg),'b','filled'); 

%%
Ngammas = 20;
Ncosts  = 20;
gamma_range = logsample(.1,1000,Ngammas);
cost_range  = logsample(.1,1000,Ncosts);

cv_error=zeros(size(gamma_range,2),size(cost_range,2));

addpath('libsvm/');
%%
for i=1:size(gamma_range,2)
    gamma=gamma_range(1,i);
    for j=1:size(cost_range,2);
        K = 10;
        cost   =cost_range(1,j);
        error  =zeros(1,K);
        fprintf('gamma = %.2f  [%i out of %i],  C = %.2f  [%i out of %i]\n',gamma,i,Ngammas,cost,j,Ncosts);

        %% use this 'parameter_string' variable as input to 'svmtrain_libsvm'
        parameter_string = sprintf('-s 0 -g %.5f -c %.5f',gamma,cost');
         
        for k=1:K
            fprintf('.');
            [trset_features,trset_labels,vlset_features,vlset_labels] =  ...
                split_data(features,labels,ndata,K,k);
            %% train your model with k-th subset of training set.
            model = svmtrain_libsvm(trset_labels', trset_features', parameter_string);
            %% estimate its error on the validation set.
            predicted_test = svmpredict_libsvm(vlset_labels', vlset_features', model);
            error(k) = mean(predicted_test ~= vlset_labels');
        end
        fprintf(' \n');
        %The generalization error is the mean of the error
        cv_error(i,j)=mean(error,2);
    end
end

figure,imagesc(cv_error)

print('-dpng','cv_error');
%%
%Pick the best gamma and cost - those that minimize the cv_error
%and train an svm using the full training set. 

[min_err, min_ind] = min(cv_error(:));
%min_err=0.148
col = floor(min_ind/Ncosts);
%cost = cost_range(col+1);
%gamma = gamma_range(min_ind - col*Ngammas);
gamma = 33.6;
cost = 4.83;
parameter_string = sprintf('-s 0 -g %.5f -c %.5f',gamma,cost);
model = svmtrain_libsvm(labels', features', parameter_string);

%% visualize the model
SVs         = model.SVs;
[gr_X,gr_Y] = meshgrid(0:.01:1,0:.01:1);
[sv,sh]     = size(gr_X);
coords      = [gr_X(:)';gr_Y(:)'];
dummy       = zeros(1,size(coords,2));

[~, ~, dec_values]   = svmpredict_libsvm(dummy',coords', model);
values               = reshape(dec_values,[sv,sh]);


figure,
subplot(1,2,1);
imshow(values,[-1,1]);
subplot(1,2,2);
contour(gr_X,gr_Y,values,[-1.0,0,1.0],'linewidth',2);
hold on,scatter(SVs(:,1),SVs(:,2),'r','filled'); 
axis off;
axis ij; 
axis equal

print('-depsc','values_svm');

%% Visuailze the data with the model
[gr_X,gr_Y] = meshgrid(0:.01:1,0:.01:1);
coords      = [gr_X(:)';gr_Y(:)'];
dummy       = zeros(1,size(coords,2));

[~, ~, dec_values]   = svmpredict_libsvm(dummy',coords', model);
values               = reshape(dec_values,[sv,sh]);


figure,
contour(gr_X,gr_Y,values,[-1.0,0,1.0],'linewidth',2);hold on,
scatter(features(1,pos),features(2,pos),'r','filled'); hold on,
scatter(features(1,neg),features(2,neg),'b','filled'); 

print('-depsc','data_svm');


%% Performance on test set
[test_features,test_labels] = construct_data(nsamples,'test',problem,'plusminus');
[predict_label, accuracy, dec_values]   = svmpredict_libsvm(test_labels', test_features', model);
nerrors = mean(predict_label~=test_labels');
%nerrors=0.18

