%%
%% Sum/Max Product Algorithms
%%
V = 1:5;
E = [1 2;1 5;2 3;2 4];
P12 = [0.1 0.9;0.5 0.2;0.1 0.1];
P23 = [0.1 0.9 0.2 0.3;0.8 0.2 0.3 0.6];
P24 = [0.1 0.9;0.8 0.2];
P15 = [0.1 0.2;0.8 0.1;0.3 0.7];
%% Computing the repartition function Z
Pt1 = sum_product(1,E);
Pt2 = sum_product(2,E);
Z = sum(Pt1);
P1 = sum_product(1,E)/Z;
P2 = sum_product(2,E)/Z;
%% Compute the probability of the graph
P = @(X) P12(X(1),X(2))*P23(X(2),X(3))*P24(X(2),X(4))*P15(X(1),X(5))/Z;
P([1 2 4 2 1])
P([3 1 2 1 2 ])
P([2 2 1 2 1])

%% Max Product Algorithm
mP1 = max_product(1,E)/Z;
mP2 = max_product(2,E)/Z;

