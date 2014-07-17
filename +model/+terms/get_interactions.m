function interactions = get_interactions(config)
%GET_INTERACTIONS Define the interaction maps used to define incluences
%   Detailed explanation goes here
    
    n_scales                          = config.wave.n_scales;
    scale_interaction_distance        = config.zli.scale_interaction_distance;
    
    [e, f]                            = model.terms.interactions.scales.get_e_f(scale_interaction_distance);
    
    interactions                      = struct;
    %% COLOR INTERACTION PARAMETERS
    % TODO
    %% SCALE INTERACTION PARAMETERS
    interactions.scale_distance       = scale_interaction_distance; % TODO rename to scale_interaction_distance
    interactions.scale_deltas         = model.terms.interactions.scales.deltas(config);
    interactions.scale_diameters      = model.terms.interactions.scales.diameters(interactions.scale_deltas);
    interactions.PsiDtheta            = model.terms.interactions.scales.psi_delta_theta(config);
    interactions.n_scale_interactions = model.terms.interactions.scales.n_scale_interactions(n_scales, scale_interaction_distance);
    interactions.border_weight        = model.terms.interactions.scales.border_weights(e, f);
    interactions.Delta_ext            = model.terms.interactions.scales.Delta_ext(scale_interaction_distance, interactions.scale_deltas, config);
    interactions.scale_filter         = model.terms.interactions.scales.filter(e, f, scale_interaction_distance);
    interactions.half_size_filter     = model.terms.interactions.scales.half_size_filter(scale_interaction_distance, interactions.scale_deltas, config);
    %% ORIENTATION INTERACTION PARAMETERS
    % TODO
end