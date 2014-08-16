function [J, W] = directional(scale_interactions, config)
%JW.DIRECTIONAL Return directional J (excitation) & W (inhibition).
%   Reference: Z. Li 1999.

    scale_deltas    = scale_interactions.deltas;
    scale_diameters = scale_interactions.diameters;
    
    n_scales   = config.wave.n_scales;
    
    [J, W] = deal(cell(n_scales, 1));
   
    for s=1:n_scales
        % TODO J & W should NOT be sized by the scale!
        scale_diameter = scale_diameters(s);
        J{s} = zeros(scale_diameter, scale_diameter, 1, 3, 3);
        W{s} = zeros(scale_diameter, scale_diameter, 1, 3, 3);
        for o=1:3
            [J{s}(:,:,1,:,o), W{s}(:,:,1,:,o)] = ...
                model.terms.interactions.orients.jw.utils.get_Jithetajtheta_v0_4( ...
                    s, o, scale_deltas(s), config.zli ...
                );
        end
    end
end