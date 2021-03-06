function [J, W] = nondirectional(scale_interactions, config)
%JW.NONDIRECTIONAL Return non-directional J (excitation) & W (inhibition).
%   J & W specify the excitatatory and inhibitory interactions between
%   neighboring neurons.

    scale_deltas    = scale_interactions.deltas;
    scale_diameters = scale_interactions.diameters;
    
    zli      = config.zli;
    n_scales = config.wave.n_scales;
    
    [J, W] = deal(cell(n_scales, 1));
   
    for s=1:n_scales
        % TODO J & W should NOT be sized by the scale!
        scale_diameter = scale_diameters(s);
        J{s} = zeros(scale_diameter, scale_diameter);
        W{s} = zeros(scale_diameter, scale_diameter);
        % J is a gaussian looking circle
        % TODO replace with a simple gaussian
        [xx, yy]     = model.terms.interactions.orients.jw.utils.gradients(scale_deltas(s));
        factor_scale = model.utils.scale2size(s, zli.scale2size_type, zli.scale2size_epsilon);
        d            = model.utils.distance_xop(xx/factor_scale, yy/factor_scale, zli.dist_type) * zli.reduccio_JW;
        ii           = find(d <= 10);
        J{s}(ii)     = 0.126*exp(-(d(ii)).^2/90);
        J{s}         = J{s} / sum(J{s}(:));
        % W is left as is, there is no non-directional inhibition
    end
end