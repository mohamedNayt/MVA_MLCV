%%
%% K-means and EM Algorithm
%%
%% Create the training data
nsamples = 1000; 

MU = [1 2;-3 -5;6 -2];
SIGMA = cat(3,[2 0;0 .5],[1 0;0 1],[2 -1;-1 2]);
p = [0.25 0.4 0.35];
obj = gmdistribution(MU,SIGMA,p);
features = random(obj,nsamples);

%% display data
fig=scatter(features(:,1),features(:,2),'r','filled');
%% Apply Kmeans algorithm
[centers,distortion] = kmeans(features,3,15);

%% display data with kmeans result
scatter(features(:,1),features(:,2),'r','filled');hold on,
scatter(centers(:,1),centers(:,2),'b','filled');
%% Plot the distortion as function of EM iterations
plot(distortion);

%% EM algorithm with kmeans initialization
covs = zeros(2,2,3);
for i=1:3
    covs(:,:,i) = eye(2);
end
p=ones(1,3)/3;
[means,covs,p,likelihood]= em_gaussianMixture(features,centers,covs,p,50);
%% Plot likelihood as function of EM iterations
plot(likelihood);
%% Plot EM clusters
hf = figure;
scatter(features(:,1),features(:,2),'r','filled');hold on,
scatter(centers(:,1),centers(:,2),'b','filled');hold on,
ezcontour(@(x,y)pdf(obj,[x y]),[-8 12],[-8 4]);
%% Bayesian classifier
x = linspace(-8,12,500);
y = linspace(-8,4,500);
[X,Y] = meshgrid(x,y);
xy = [X(:) Y(:)];
zz = bayes_posterior(xy,means,covs,p);
Z = reshape(zz,size(X));
scatter(features(:,1),features(:,2),'r','filled');hold on,
scatter(centers(:,1),centers(:,2),'b','filled');hold on,
ezcontour(@(x,y)pdf(obj,[x y]),[-8 12],[-8 4]);hold on,
contour(X,Y,Z,3);

