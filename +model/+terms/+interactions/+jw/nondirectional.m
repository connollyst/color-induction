function [J, W] = nondirectional(interactions, config)
%JW.NONDIRECTIONAL Return non-directional J (excitation) & W (inhibition).
%   J & W specify the excitatatory and inhibitory interactions between
%   neighboring neurons.

    % TODO perhaps J & W don't need the interactions?
    scale_deltas    = interactions.scale_deltas;
    scale_diameters = interactions.scale_diameters;
    
    zli      = config.zli;
    n_scales = config.wave.n_scales;
    J        = cell(n_scales, 1);
    W        = cell(n_scales, 1);
   
    for s=1:n_scales
        % TODO J & W should NOT be sized by the scale!
        scale_diameter = scale_diameters(s);
        J{s} = zeros(scale_diameter, scale_diameter);
        W{s} = zeros(scale_diameter, scale_diameter);
        % J is a gaussian looking circle
        [xx, yy]     = model.terms.interactions.jw.utils.gradients(scale_deltas(s));
        factor_scale = model.utils.scale2size(s, zli.scale2size_type, zli.scale2size_epsilon);
        d            = model.utils.distance_xop(xx/factor_scale, yy/factor_scale, zli.dist_type) * zli.reduccio_JW;
        ii           = find(d <= 10);
        J{s}(ii)     = 0.126*exp(-(d(ii)).^2/90);
        % W is left as is, there is no non-directional inhibition
    end
end