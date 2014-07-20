function I_norm = normalization(norm_mask, gx_padded, scale_interactions, config)
%NORMALIZATION
%   We generalize Z.Li's formula for the normalization by suming over all
%   the scales within a given hypercolumn (cf. p209, where she already sums
%   over all the orientations)

    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    r                   = config.zli.normalization_power;
    inv_den             = norm_mask.inv_den;
    M_norm_conv         = norm_mask.M_norm_conv;
    M_norm_conv_fft     = norm_mask.M_norm_conv_fft;
    scale_distance      = scale_interactions.distance;
    Delta_ext           = scale_interactions.Delta_ext;
    
    I_norm = model.utils.zeros(config);
    for s=scale_distance+1:scale_distance+n_scales
        s2 = s - scale_distance;
        radi=(size(M_norm_conv{s2})-1)/2;
        % sum over all the orientations
        gx_padded_sc = sum(gx_padded{s}, 5);
        despl = radi;
        for c=1:n_channels
            kk = model.data.convolutions.optima( ...
                gx_padded_sc( ...
                    Delta_ext(s) + 1 - radi(1) : Delta_ext(s) + n_cols + radi(1), ...
                    Delta_ext(s) + 1 - radi(2) : Delta_ext(s) + n_rows + radi(2), ...
                    c ...
                ), ...
                M_norm_conv_fft{s2}, despl, 1, avoid_circshift_fft ...
            ); % Xavier. El filtre diria que ha d'estar normalitzat per tal de calcular el valor mig
            kk_cols = radi(1) + 1 : n_cols + radi(1);
            kk_rows = radi(2) + 1 : n_rows + radi(2);
            I_norm_s2 = repmat(kk(kk_cols, kk_rows), [1 1 n_orients]);
            I_norm(:, :, c, s2, :) = I_norm_s2;
        end
    end
    for s=1:n_scales  % times roughly 50 if the flag is 1
        I_norm(:,:,:,s,:) = -2 * (I_norm(:,:,:,s,:) * inv_den{s}) .^ r;
    end
end