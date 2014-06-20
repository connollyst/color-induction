function weights=get_border_weights(a,b)
%Compute the weights of the vectors used to complete the padding

    if a > 0.001
        alpha   = (4*a-b)./(3*a);
        weights = [alpha  1-alpha];
    else
        weights = [0 0];
    end

end