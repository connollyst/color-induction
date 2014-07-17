function interactions = get_interactions(config)
%GET_INTERACTIONS Define the interaction maps used to define incluences
%   Detailed explanation goes here
    
    interactions                        = struct;
    
    %% COLOR INTERACTION PARAMETERS
    interactions.color.filter           = model.terms.interactions.colors.filter(config);
    
    %% SCALE INTERACTION PARAMETERS
    interactions.scale.distance         = config.zli.scale_interaction_distance;
    interactions.scale.deltas           = model.terms.interactions.scales.deltas(config);
    interactions.scale.diameters        = model.terms.interactions.scales.diameters(interactions.scale.deltas);
    interactions.scale.n_interactions   = model.terms.interactions.scales.n_scale_interactions(config.wave.n_scales, interactions.scale.distance);
    interactions.scale.filter           = model.terms.interactions.scales.filter(interactions.scale.distance);
    interactions.scale.border_weight    = model.terms.interactions.scales.border_weights(interactions.scale.distance);
    interactions.scale.filter_half_size = model.terms.interactions.scales.filter_half_size(interactions.scale.distance, interactions.scale.deltas, config);
    interactions.scale.Delta_ext        = model.terms.interactions.scales.Delta_ext(interactions.scale.distance, interactions.scale.deltas, config);
    
    %% ORIENTATION INTERACTION PARAMETERS
    interactions.orient.JW              = model.terms.interactions.orients.JW(interactions.scale, config);
    interactions.orient.PsiDtheta       = model.terms.interactions.orients.psi_delta_theta(config);
end