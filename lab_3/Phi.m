function mat=Phi(edge)
    P12 = [0.1 0.9;0.5 0.2;0.1 0.1];
    P23 = [0.1 0.9 0.2 0.3;0.8 0.2 0.3 0.6];
    P24 = [0.1 0.9;0.8 0.2];
    P15 = [0.1 0.2;0.8 0.1;0.3 0.7];
    if isequal(sort(edge),[1 2])
        if edge(1)<edge(2)
            mat = P12;
        else
            mat = transpose(P12);
        end
    elseif isequal(sort(edge),[2 3])
        if edge(1)<edge(2)
            mat = P23;
        else
            mat = transpose(P23);
        end
    elseif isequal(sort(edge),[2 4])
        if edge(1)<edge(2)
            mat = P24;
        else
            mat = transpose(P24);
        end
    elseif isequal(sort(edge),[1 5])
        if edge(1)<edge(2)
            mat = P15;
        else
            mat = transpose(P15);
        end
    end
end