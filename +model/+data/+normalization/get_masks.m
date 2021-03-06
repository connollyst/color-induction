function norm_mask = get_masks(config)
%GET_MASKS Returns the normalization masks for each scale.
%   Generates and returns a structure array containing the original and
%   FFT normalization convolution masks for each scale.
    
    [M_norm_conv, inv_den] = compute_M_norm_conv(config);
    M_norm_conv_fft        = compute_M_norm_conv_fft(M_norm_conv, config);
    
    % Package up results to be returned
    norm_mask = struct;
    norm_mask.M_norm_conv     = M_norm_conv;
    norm_mask.M_norm_conv_fft = M_norm_conv_fft;
    norm_mask.inv_den         = inv_den;
end

function [M_norm_conv, inv_den] = compute_M_norm_conv(config)
    n_scales    = config.wave.n_scales;
    dist_type   = config.zli.dist_type;
    scale_type  = config.zli.scale2size_type;
    epsilon     = config.zli.scale2size_epsilon;
    M_norm_conv = cell(n_scales, 1);
    inv_den     = cell(n_scales, 1);
    for s=1:n_scales
        radi           = model.utils.scale2size(s+1, scale_type, epsilon);
        factor_scale   = model.utils.scale2size(s,   scale_type, epsilon);
        M_norm_conv{s} = zeros(2*radi+1, 2*radi+1);
        xx             = repmat((-radi:1:radi),  2*radi+1, 1);
        yy             = repmat((-radi:1:radi)', 1, 2*radi+1);
        d              = model.utils.distance_xop(xx/factor_scale, yy/factor_scale, dist_type);
        M_norm_conv{s}(d<=2) = 1;
        inv_den{s} = 1/sum(M_norm_conv{s}(:));
    end
end

function M_norm_conv_fft = compute_M_norm_conv_fft(M_norm_conv, config)
    n_scales        = config.wave.n_scales;
    n_cols          = config.image.width;
    n_rows          = config.image.height;
    M_norm_conv_fft = cell(n_scales, 1);
    for s=1:n_scales
        if config.compute.use_fft
            radi=(size(M_norm_conv{s})-1)/2;
            if config.compute.avoid_circshift_fft==1
                % fft that do not requires circshift (by far better)
                M_circ=padarray(M_norm_conv{s},[n_cols+2*radi(1)-(radi(1)*2+1),n_rows+2*radi(2)-(radi(2)*2+1)],0,'post');
                M_circ=circshift(M_circ,-radi);
                M_norm_conv_fft{s}=fftn(M_circ);
            else
                % this fft requires circshift (slower)
                M_norm_conv_fft{s}=fftn(M_norm_conv{s},[n_cols+2*radi(1),n_rows+2*radi(2)]);
            end
        end
    end
end