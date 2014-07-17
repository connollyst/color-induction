function n_scale_interactions = n_scale_interactions(n_scales, scale_interaction_distance)
% The number of interactions: each scale and it's interactions on either
% side, up to the scale interactions distance
    n_scale_interactions = n_scales + 2 * scale_interaction_distance;
end