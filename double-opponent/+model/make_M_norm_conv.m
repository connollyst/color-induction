function [M_norm_conv, M_norm_conv_fft, inv_den] = make_M_norm_conv(M, N, config)
    n_scales    = config.wave.n_scales;
    dist_type   = config.zli.dist_type;
    scale_type  = config.zli.scale2size_type;
    epsilon     = config.zli.scale2size_epsilon;
    M_norm_conv = cell(n_scales, 1);
    inv_den     = cell(n_scales, 1);
    for s=1:n_scales
        radi           = utils.scale2size(s+1, scale_type, epsilon);
        factor_scale   = utils.scale2size(s,   scale_type, epsilon);

        M_norm_conv{s} = zeros(2*radi+1, 2*radi+1);

        xx = repmat((-radi:1:radi),  2*radi+1, 1);
        yy = repmat((-radi:1:radi)', 1, 2*radi+1);

        d = utils.distance_xop(xx/factor_scale, yy/factor_scale, dist_type);

        M_norm_conv{s}(d<=2) = 1;
        inv_den{s} = 1/sum(M_norm_conv{s}(:));
    end
    M_norm_conv_fft = compute_M_norm_conv_fft(M, N, M_norm_conv, n_scales, config);
end

function M_norm_conv_fft = compute_M_norm_conv_fft(M, N, M_norm_conv, n_scales, config)
    M_norm_conv_fft  = cell(n_scales,1);
    for s=1:n_scales
        if config.compute.use_fft
            radi=(size(M_norm_conv{s})-1)/2;
            if config.compute.avoid_circshift_fft==1
                % fft that do not requires circshift (by far better)
                M_circ=padarray(M_norm_conv{s},[M+2*radi(1)-(radi(1)*2+1),N+2*radi(2)-(radi(2)*2+1)],0,'post');
                M_circ=circshift(M_circ,-radi);
                M_norm_conv_fft{s}=fftn(M_circ);
            else
                % this fft requires circshift (slower)
                M_norm_conv_fft{s}=fftn(M_norm_conv{s},[M+2*radi(1),N+2*radi(2)]);
            end
        end
    end
end