function [M_norm_conv, inv_den] = make_M_norm_conv(config)
    n_scales    = config.wave.n_scales;
    dist_type   = config.zli.dist_type;
    scale_type  = config.zli.scale2size_type;
    epsilon     = config.zli.scale2size_epsilon;
    M_norm_conv = cell(n_scales, 1);
    inv_den     = cell(n_scales, 1);
    for i=1:n_scales
        radi           = utils.scale2size(i+1, scale_type, epsilon);
        factor_scale   = utils.scale2size(i,   scale_type, epsilon);

        M_norm_conv{i} = zeros(2*radi+1, 2*radi+1);

        xx = repmat((-radi:1:radi),  2*radi+1, 1);
        yy = repmat((-radi:1:radi)', 1, 2*radi+1);

        d = utils.distance_xop(xx/factor_scale, yy/factor_scale, dist_type);

        M_norm_conv{i}(d<=2) = 1;
        inv_den{i} = 1/sum(M_norm_conv{i}(:));
    end
end