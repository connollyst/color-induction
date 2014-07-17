function weights = border_weights(scale_interaction_distance)
%Compute the weights of the vectors used to complete the padding
    [e, f] = model.terms.interactions.scales.get_e_f(scale_interaction_distance);
    if e > 0.001
        alpha   = (4*e-f)./(3*e);
        weights = [alpha  1-alpha];
    else
        weights = [0 0];
    end
end