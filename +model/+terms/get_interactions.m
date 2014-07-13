function interactions = get_interactions(config)
%INTERACTION_MAP Define the interaction maps used to define incluences
%   Detailed explanation goes here
    
    n_scales                          = config.wave.n_scales;
    scale_interaction_distance        = config.zli.scale_interaction_distance;
    
    [e, f]                            = get_e_f(scale_interaction_distance);
    
    interactions                      = struct;
    interactions.scale_deltas         = model.utils.calculate_scale_deltas(config);
    interactions.PsiDtheta            = model.terms.get_psi_delta_theta();
    interactions.scale_distance       = scale_interaction_distance; % TODO rename to scale_interaction_distance
    interactions.n_scale_interactions = get_n_scale_interactions(n_scales, scale_interaction_distance);
    interactions.border_weight        = get_border_weights(e, f);
    interactions.Delta_ext            = get_Delta_ext(scale_interaction_distance, interactions.scale_deltas, config);
    interactions.scale_filter         = get_scale_filter(e, f, scale_interaction_distance);
    interactions.half_size_filter     = get_half_size_filter(scale_interaction_distance, interactions.scale_deltas, config);
end

function [e, f] = get_e_f(scale_interaction)
    if scale_interaction > 1 || scale_interaction < 0
        error(['border_weights only handle scale_interaction of 1 or 0,' ...
               ' scale_interaction is %i'], scale_interaction);
    end
    if scale_interaction == 1
        e = 0.01;
        f = 1;
    end
    if scale_interaction == 0
        e = 0;
        f = 1;
    end
end

function n_scale_interactions = get_n_scale_interactions(n_scales, scale_interaction_distance)
% The number of interactions: each scale and it's interactions on either
% side, up to the scale interactions distance
    n_scale_interactions = n_scales + 2 * scale_interaction_distance;
end

function Delta_ext = get_Delta_ext(scale_distance, scale_deltas, config)
    n_scales      = config.wave.n_scales;
    Delta_ext     = zeros(1, n_scales+scale_distance*2);
    Delta_ext(scale_distance+1:n_scales+scale_distance)            = scale_deltas;
    Delta_ext(1:scale_distance)                                    = scale_deltas(1);
    Delta_ext(n_scales+scale_distance+1:n_scales+scale_distance*2) = scale_deltas(n_scales);
end

function scale_filter = get_scale_filter(e, f, scale_interaction_distance)
% Filter used to apply weights to scale interactions
    scale_filter                = zeros(1, 1, 1, 1+2*scale_interaction_distance, 1);
    scale_filter(1, 1, 1, :, 1) = [e f e];
end

function half_size_filter = get_half_size_filter(scale_interaction_distance, scale_deltas, config)
    n_scales         = config.wave.n_scales;
    half_size_filter = cell(n_scales,1);
    for s=1:n_scales
        if scale_interaction_distance > 0
            half_size_filter{s} = [scale_deltas(s) scale_deltas(s) 0];
        end
    end
end

function weights = get_border_weights(a,b)
%Compute the weights of the vectors used to complete the padding
    if a > 0.001
        alpha   = (4*a-b)./(3*a);
        weights = [alpha  1-alpha];
    else
        weights = [0 0];
    end
end