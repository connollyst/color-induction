function interactions = get_interactions(Delta, config)
%INTERACTION_MAP Define the interaction maps used to define incluences
%   Detailed explanation goes here
    
    n_scales                      = config.wave.n_scales;
    scale_interaction             = config.zli.scale_interaction;
    
    [e, f]                        = get_e_f(scale_interaction);
    
    interactions                  = struct;
    interactions.PsiDtheta        = model.terms.get_psi_delta_theta();
    interactions.scale_distance   = scale_interaction; % TODO rename to scale_interaction
    interactions.border_weight    = model.get_border_weights(e, f);
    interactions.Delta_ext        = get_Delta_ext(n_scales, scale_interaction, Delta);
    interactions.scale_filter     = get_scale_filter(e, f, scale_interaction);
    interactions.half_size_filter = get_half_size_filter(n_scales, scale_interaction, Delta);
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

function Delta_ext = get_Delta_ext(n_scales, scale_interaction, Delta)
    n_scale_interactions = n_scales+scale_interaction*2;
    Delta_ext = zeros(1, n_scale_interactions);
    Delta_ext(scale_interaction+1:n_scales+scale_interaction)    = Delta;
    Delta_ext(1:scale_interaction)                               = Delta(1);
    Delta_ext(n_scales+scale_interaction+1:n_scale_interactions) = Delta(n_scales);
end

function scale_filter = get_scale_filter(e, f, scale_interaction)
% Filter used to apply weights to scale interactions
    scale_filter                = zeros(1, 1, 1, 1+2*scale_interaction, 1);
    scale_filter(1, 1, 1, :, 1) = [e f e];
end

function half_size_filter = get_half_size_filter(n_scales, scale_interaction, Delta)
    half_size_filter = cell(n_scales,1);
    for s=1:n_scales
        if scale_interaction >0
            half_size_filter{s} = [Delta(s) Delta(s) 0];
        end
    end
end

