function n=neighbors(i,E)
    n=[];
    for j=1:size(E,1)
        if E(j,1) == i
            n = [n E(j,2)];
        elseif E(j,2) == i
            n = [n E(j,1)];
        end
    end
end