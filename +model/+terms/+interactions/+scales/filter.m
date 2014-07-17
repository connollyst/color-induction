function scale_filter = filter(e, f, scale_interaction_distance)
% Filter used to apply weights to scale interactions
    scale_filter = zeros(1, 1, 1, 1+2*scale_interaction_distance, 1);
    scale_filter(1, 1, 1, :, 1) = [e f e];
end