function [x_ee, x_ei, y_ie] = get_excitation_and_inhibition(gx_padded, gy, JW, interactions, config)
%GET_EXCITATION_AND_INHIBITION

    scale_filter = interactions.scale_filter;
    n_cols       = config.image.width;
    n_rows       = config.image.height;
    n_channels   = config.image.n_channels;
    n_scales     = config.wave.n_scales;
    n_orients    = config.wave.n_orients;
    use_fft      = config.compute.use_fft;
    
    [x_ee, x_ei, y_ie]   = deal(zeros(n_cols, n_rows, n_channels, n_scales, n_orients));

    if use_fft
        gx_padded = to_fft(gx_padded, interactions, config);
    end

    % influence of the neighboring scales first
    for oc=1:n_orients  % loop over the central (reference) orientation
        x_ei(:,:,:,:,oc)   = get_x_ei(oc, gy, interactions, config);
        [x_ee_oc, y_ie_oc] = get_x_ee_y_ie(oc, gx_padded, JW, interactions, config);
        x_ee(:,:,:,:,oc)   = sum(x_ee_oc, 5);
        y_ie(:,:,:,:,oc)   = sum(y_ie_oc, 5);
    end
    
    % influence of the neighboring spatial frequencies
    x_ee = convolutions.optima(x_ee, scale_filter, 0, 0);
    y_ie = convolutions.optima(y_ie, scale_filter, 0, 0);
end

function newgx_toroidal_x_fft = to_fft(newgx_toroidal_x, interactions, config)
% Preprocess the input data to Fourier space for faster processing.

    scale_distance = interactions.scale_distance;
    n_channels     = config.image.n_channels;
    n_scales       = config.wave.n_scales;
    n_orients      = config.wave.n_orients;
    
    newgx_toroidal_x_fft = cell(scale_distance+n_scales, n_channels);
    for s=1:n_scales
        for c=1:n_channels
            for ov=1:n_orients  % loop over all the orientations given the central (reference orientation)
                newgx_toroidal_x_fft{scale_distance+s,c}{ov} = fftn(newgx_toroidal_x{scale_distance+s}(:,:,c,ov));
            end
        end
    end
end

function x_ei = get_x_ei(oc, gy, interactions, config)
% Excitatory-inhibitory term (no existia): x_ei

    scale_distance      = interactions.scale_distance;
    scale_filter        = interactions.scale_filter;
    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    
    sum_scale_newgy_toroidal_y = convolutions.optima(gy,scale_filter,0,0,avoid_circshift_fft); % does it give the right dimension? 'same' needed?
    restr_sum_scale_newgy_toroidal_y = sum_scale_newgy_toroidal_y(:,:,:,scale_distance+1:scale_distance+n_scales,:); % restriction over scales
    w = zeros(1,1,1,1,n_orients); w(1,1,1,1,:) = interactions.PsiDtheta(oc,:);
    x_ei = sum(restr_sum_scale_newgy_toroidal_y .* repmat(w,[n_cols,n_rows,n_channels,n_scales,1]), 5);
end

function [x_ee_conv_tmp, y_ie_conv_tmp] = get_x_ee_y_ie(oc, gx_padded, JW, interactions, config)
% Excitatory and inhibitory terms (the big sums)
% excitatory-excitatory term:    x_ee
% excitatory-inhibitory term:    y_ie
        
    half_size_filter    = interactions.half_size_filter;
    scale_distance      = interactions.scale_distance;
    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    scale_deltas        = config.wave.scale_deltas;
    use_fft             = config.compute.use_fft;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    
    x_ee_conv_tmp = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    y_ie_conv_tmp = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    for ov=1:n_orients  % loop over all the orientations given the central (reference orientation)
        if use_fft
            for s=1:n_scales
                cols     = scale_deltas(s)+1:scale_deltas(s)+n_cols;
                rows     = scale_deltas(s)+1:scale_deltas(s)+n_rows;
                J_fft_s  = JW.J_fft{s}(:,:,1,ov,oc);
                W_fft_s  = JW.W_fft{s}(:,:,1,ov,oc);
                s_filter = half_size_filter{s};
                for c=1:n_channels
                    x_fft    = gx_padded{scale_distance+s,c}{ov};
                    x_fft_J  = convolutions.optima_fft(x_fft, J_fft_s, s_filter, avoid_circshift_fft);
                    x_fft_W  = convolutions.optima_fft(x_fft, W_fft_s, s_filter, avoid_circshift_fft);
                    x_ee_conv_tmp(:,:,c,s,ov) = x_fft_J(cols, rows);
                    y_ie_conv_tmp(:,:,c,s,ov) = x_fft_W(cols, rows);
                end
            end
        else
            error('Non FFT approach is not implemented.');
        end
    end
end