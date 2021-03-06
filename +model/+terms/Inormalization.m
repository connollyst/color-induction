function I_norm = Inormalization(gx, norm_mask, scale_interactions, config)
%MODEL.TERMS.INORMALIZATION Generate normalization term.
%                           p.209, Li 1999
%   We generalize Z.Li's formula for the normalization by suming over all
%   the scales and color channels within a given hypercolumn (cf. p209,
%   where she already sums over all the orientations).

    n_scales  = config.wave.n_scales;
    n_orients = config.wave.n_orients;
    r         = config.zli.normalization_power;
    inv_den   = norm_mask.inv_den;
    gx_padded = model.data.padding.add.orient(gx, scale_interactions, config);
    
    if config.rf.so.enabled && config.rf.do.enabled
        % If we are processing both SO and DO, normalize them separately..
        DO_norm = get_normalization(gx_padded, 1:3, norm_mask, scale_interactions, config);
        SO_norm = get_normalization(gx_padded, 4,   norm_mask, scale_interactions, config);
        I_norm  = cat(5, DO_norm, SO_norm);
    else
        I_norm  = get_normalization(gx_padded, 1:n_orients, norm_mask, scale_interactions, config);
    end

    for s=1:n_scales  % times roughly 50 if the flag is 1
        I_norm(:,:,:,s,:) = -2 * (I_norm(:,:,:,s,:) * inv_den{s}) .^ r;
    end
end

function I_norm = get_normalization(gx_padded, orients, norm_mask, scale_interactions, config)
    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = length(orients);
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    M_norm_conv         = norm_mask.M_norm_conv;
    M_norm_conv_fft     = norm_mask.M_norm_conv_fft;
    scale_distance      = scale_interactions.distance;
    Delta_ext           = scale_interactions.Delta_ext;
    I_norm              = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    for s=scale_distance+1:scale_distance+n_scales
        s2 = s - scale_distance;
        radi=(size(M_norm_conv{s2})-1)/2;
        % sum over all the orientations
        gx_padded_sc = sum(gx_padded{s}(:,:,:,:,orients), 5);
        despl = radi;
        for c=1:n_channels
            kk = model.data.convolutions.optimal( ...
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
end