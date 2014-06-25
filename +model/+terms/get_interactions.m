function interactions = get_interactions(Delta, config)
%INTERACTION_MAP Define the interaction maps used to define incluences
%   Detailed explanation goes here
    
    n_scales                      = config.wave.n_scales;
    scale_interaction_distance    = config.zli.scale_interaction_distance;
    
    [e, f]                        = get_e_f(scale_interaction_distance);
    
    interactions                  = struct;
    interactions.PsiDtheta        = model.terms.get_psi_delta_theta();
    interactions.scale_distance   = scale_interaction_distance; % TODO rename to scale_interaction_distance
    interactions.border_weight    = model.get_border_weights(e, f);
    interactions.Delta_ext        = get_Delta_ext(n_scales, scale_interaction_distance, Delta);
    interactions.scale_filter     = get_scale_filter(e, f, scale_interaction_distance);
    interactions.half_size_filter = get_half_size_filter(n_scales, scale_interaction_distance, Delta);
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

function Delta_ext = get_Delta_ext(n_scales, scale_interaction_distance, Delta)
    n_scale_interactions = n_scales+scale_interaction_distance*2;
    a = 1:scale_interaction_distance;
    b = n_scales+scale_interaction_distance;
    Delta_ext = zeros(1, n_scale_interactions);
    Delta_ext(scale_interaction_distance+1:b) = Delta;
    Delta_ext(a)                              = Delta(1);
    Delta_ext(b+1:scale_interaction_distance) = Delta(n_scales);
end

function scale_filter = get_scale_filter(e, f, scale_interaction_distance)
% Filter used to apply weights to scale interactions
    scale_filter                = zeros(1, 1, 1, 1+2*scale_interaction_distance, 1);
    scale_filter(1, 1, 1, :, 1) = [e f e];
end

function half_size_filter = get_half_size_filter(n_scales, scale_interaction_distance, Delta)
    half_size_filter = cell(n_scales,1);
    for s=1:n_scales
        if scale_interaction_distance > 0
            half_size_filter{s} = [Delta(s) Delta(s) 0];
        end
    end
end

