function [x_ee_oc, y_ie_oc] = x_ee_y_ie(oc, gx_padded, JW, interactions, config)
% Excitatory and inhibitory terms (the big sums)
% excitatory-excitatory term:    x_ee
% excitatory-inhibitory term:    y_ie
    
    x_ee_oc = apply_filter(oc, gx_padded, JW.J_fft, interactions, config);
    y_ie_oc = apply_filter(oc, gx_padded, JW.W_fft, interactions, config);
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