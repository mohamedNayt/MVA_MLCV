%% Create the training data
nsamples = 1000; 
problem  = 'linear';
[train_features,train_labels] = construct_data(nsamples,'train',problem);
[test_features, test_labels ] = construct_data(nsamples,'test', problem);

%% display your data
pos = find(train_labels==1);
neg = find(train_labels~=1);

hf = figure;
scatter(train_features(1,pos),train_features(2,pos),'r','filled'); hold on,
scatter(train_features(1,neg),train_features(2,neg),'b','filled'); 

%%---------------------------------------------------------------
%% First part - (done for you) 
%%---------------------------------------------------------------

%% Train a linear classifier 

%% in slide 31, Lecture 1, X was (Ndata x Ndimensions), Y was (Ndata x 1)
%% Now the size of train_features is Ndimensions x Ndata and of Y is 1 x Ndata
%% so we transpose train_features and train_data to get X and Y respectively
X = train_features';
Y = train_labels';

%%  form X^T X
XX = X'*X;  

%%  form X^T Y
YX = X'*Y;
%%  solve   w  = (X^T X)^{-1}  (X^T Y)
w = inv(XX)*YX;

%% threshold output at 0.5
predicted_label_test    = (w'*test_features >.5);
nerrors                 = length(find(predicted_label_test~=test_labels));
err_lin = nerrors/length(test_labels);
%% visualize classifier 

%% step 1: get its value over a regular grid of positions
[function_values,grid_x,grid_y] = evaluate_linear_discriminant_on_grid(w,[0:.01:1],[0:.01:1]);

%% step 2: plot the set of positions where its value equals .5 
hf = figure;
[d,h] = contour(grid_x,grid_y,function_values,[.5,.5],'linewidth',2);

%% step 3: superimpose the points of the test set
hold on;
pos = find(test_labels==1);
neg = find(test_labels~=1);

scatter(test_features(1,pos),test_features(2,pos),'r','filled'); 
scatter(test_features(1,neg),test_features(2,neg),'b','filled'); 

%% step 4: generate figure
print('-depsc','decision_boundary_linear');


%%---------------------------------------------------------------
%% Second part -  logistic regression (your turn)
%%---------------------------------------------------------------

w = [0;0;0]; %% initialize w randomly
k = 0;
while 1 %% continue until convergence criterion is met 
    k = k +1;
    w_prev = w;
    
    %% update w (Newton-Raphson)
    % compute the gradient at w
    J = X'*(Y - sigmf(X*w,[1,0]));
    % compute the hessian
    R = diag(sigmf(X*w,[1,0]).*(1-sigmf(X*w,[1,0])));
    H = -X'*R*X;
    % update w
    w = w - H\J; 
    score(k) = sum(Y.*log(sigmf(X*w,[1,0])) + (1-Y).*log(1-sigmf(X*w,[1,0])));
        
    %% convergence criterion
    if sqrt(sum((w-w_prev).^2))/sqrt(sum(w.^2))<.01
        break
    end
end
figure,plot(score,'linewidth',2)
print('-depsc','score');


%% step 1: get its value over a regular grid of positions
[function_values,grid_x,grid_y] = evaluate_linear_discriminant_on_grid(w,[0:.01:1],[0:.01:1]);
sigmoidal_values = 1./(1+exp(-function_values));

%% estimate number of misclassified test points
predicted_label_test    = (1./(1+exp(-w'*test_features)) >.5);
nerrors                 = length(find(predicted_label_test~=test_labels));
err_log = nerrors / length(test_labels)
%% step 2: plot the set of positions where its value equals .5 
hf = figure;
[d,h] = contour(grid_x,grid_y,sigmoidal_values,[.5,.5],'linewidth',2);

%% step 3: superimpose the points of the test set
hold on;
pos = find(test_labels==1);
neg = find(test_labels~=1);

scatter(test_features(1,pos),test_features(2,pos),'r','filled'); 
scatter(test_features(1,neg),test_features(2,neg),'b','filled'); 

print('-depsc','contours1');