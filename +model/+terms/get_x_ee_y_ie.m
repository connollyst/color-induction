function [x_ee, y_ie] = get_x_ee_y_ie(gx_padded, JW, interactions, config)
%GET_X_EE_Y_IE Calculate the excitatory and inhibitory terms.
%   Input
%       gx_padded:      the gx input data, padded to avoid edge effects
%       JW:             the struct of J and W interaction data
%       interactions:   the struct of interaction parameters
%       config:         the struct of algorithm configuration parameters
%   Output
%       x_ee: excitatory-excitatory term
%       y_ie: excitatory-inhibitory term

    scale_filter = interactions.scale_filter;
    n_cols       = config.image.width;
    n_rows       = config.image.height;
    n_channels   = config.image.n_channels;
    n_scales     = config.wave.n_scales;
    n_orients    = config.wave.n_orients;
    
    % TODO if use_fft is false, gx_padded is the wrong structure
    if config.compute.use_fft
        gx_padded = to_fft(gx_padded, interactions, config);
    end
    
    [x_ee, y_ie] = deal(zeros(n_cols, n_rows, n_channels, n_scales, n_orients));
    
    for oc=1:n_orients  % loop over the central (reference) orientation
        x_ee(:,:,:,:,oc) = apply_filter(oc, gx_padded, JW.J_fft, interactions, config);
        y_ie(:,:,:,:,oc) = apply_filter(oc, gx_padded, JW.W_fft, interactions, config);
    end
    
    x_ee = convolutions.optima(x_ee, scale_filter, 0, 0);
    y_ie = convolutions.optima(y_ie, scale_filter, 0, 0);
end

function gx_padded_fft = to_fft(gx_padded, interactions, config)
% Preprocess the input data to Fourier space for faster processing.

    scale_distance = interactions.scale_distance;
    n_channels     = config.image.n_channels;
    n_scales       = config.wave.n_scales;
    n_orients      = config.wave.n_orients;
    
    gx_padded_fft = cell(scale_distance+n_scales, n_channels);
    for s=1:n_scales
        for c=1:n_channels
            for ov=1:n_orients  % loop over all the orientations given the central (reference orientation)
                % TODO the cell arrays have different sizes
                gx_padded_fft{scale_distance+s,c}{ov} = fftn(gx_padded{scale_distance+s}(:,:,c,ov));
            end
        end
    end
end

function gx_filtered = apply_filter(oc, gx_padded, filter_fft, interactions, config)
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
    
    gx_filtered = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    for ov=1:n_orients  % loop over all the orientations given the central (reference orientation)
        for s=1:n_scales
            cols         = scale_deltas(s)+1:scale_deltas(s)+n_cols;
            rows         = scale_deltas(s)+1:scale_deltas(s)+n_rows;
            filter_fft_s = filter_fft{s}(:,:,1,ov,oc);
            shift_size   = half_size_filter{s};
            if use_fft
                for c=1:n_channels
                    x_fft    = gx_padded{scale_distance+s,c}{ov};
                    x_fft_J  = convolutions.optima_fft(x_fft, filter_fft_s, shift_size, avoid_circshift_fft);
                    gx_filtered(:,:,c,s,ov) = x_fft_J(cols, rows);
                end
            else
                for c=1:n_channels
                    % TODO why is gx_padded size not the same in FFT?
                    x    = gx_padded{scale_distance+s}(:,:,c,ov);
                    x_J  = convolutions.optima(x, filter_fft_s, shift_size, 1, avoid_circshift_fft);
                    gx_filtered(:,:,c,s,ov) = x_J(cols, rows);
                end
            end
        end
    end
    gx_filtered = sum(gx_filtered, 5);
end
