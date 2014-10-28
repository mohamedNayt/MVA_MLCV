function J = compute_J(X, Y, w)
D = Y - sigmf(X*w,[1,0]);
J = X'*D;
end

function H = compute_H(X,w)
R = diag(sigmf(X*w,[1,0]).*(1-sigmf(X*w,[1,0])));
H = -X'*R*X;
end