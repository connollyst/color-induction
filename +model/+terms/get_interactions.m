function interactions = get_interactions(config)
%GET_INTERACTIONS Define the interaction maps used to define incluences
%   Detailed explanation goes here
    
    interactions                        = struct;
    
    %% COLOR INTERACTION PARAMETERS
    interactions.color.filter           = model.terms.interactions.colors.filter(config);
    
    %% SCALE INTERACTION PARAMETERS
    n_scales                            = config.wave.n_scales;
    scale_interaction_distance          = config.zli.scale_interaction_distance;
    [e, f]                              = model.terms.interactions.scales.get_e_f(scale_interaction_distance);
    interactions.scale.distance         = scale_interaction_distance; % TODO rename to scale_interaction_distance
    interactions.scale.deltas           = model.terms.interactions.scales.deltas(config);
    interactions.scale.diameters        = model.terms.interactions.scales.diameters(interactions.scale.deltas);
    interactions.scale.PsiDtheta        = model.terms.interactions.scales.psi_delta_theta(config);
    interactions.scale.n_interactions   = model.terms.interactions.scales.n_scale_interactions(n_scales, scale_interaction_distance);
    interactions.scale.border_weight    = model.terms.interactions.scales.border_weights(e, f);
    interactions.scale.Delta_ext        = model.terms.interactions.scales.Delta_ext(scale_interaction_distance, interactions.scale.deltas, config);
    interactions.scale.filter           = model.terms.interactions.scales.filter(e, f, scale_interaction_distance);
    interactions.scale.filter_half_size = model.terms.interactions.scales.half_size_filter(scale_interaction_distance, interactions.scale.deltas, config);
    
    %% ORIENTATION INTERACTION PARAMETERS
    % Prepare J & W: the excitatory and inhibitory masks
    interactions.orient.JW              = model.terms.interactions.orients.JW(interactions.scale, config);
end