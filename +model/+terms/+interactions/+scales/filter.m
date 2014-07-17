function scale_filter = filter(scale_interaction_distance)
%MODEL.TERMS.INTERACTIONS.SCALES.FILTER 
%   Returns the filter used to apply weights to scale interactions
    [e, f] = model.terms.interactions.scales.get_e_f(scale_interaction_distance);
    scale_interactions = 1 + 2 * scale_interaction_distance;
    scale_filter = zeros(1, 1, 1, scale_interactions, 1);
    scale_filter(1, 1, 1, :, 1) = [e f e];
end