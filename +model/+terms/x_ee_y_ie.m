function [x_ee_oc, y_ie_oc] = x_ee_y_ie(oc, gx_padded, JW, interactions, config)
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
    
    x_ee_oc = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    y_ie_oc = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    for ov=1:n_orients  % loop over all the orientations given the central (reference orientation)
        for s=1:n_scales
            cols       = scale_deltas(s)+1:scale_deltas(s)+n_cols;
            rows       = scale_deltas(s)+1:scale_deltas(s)+n_rows;
            J_fft_s    = JW.J_fft{s}(:,:,1,ov,oc);
            W_fft_s    = JW.W_fft{s}(:,:,1,ov,oc);
            shift_size = half_size_filter{s};
            if use_fft
                for c=1:n_channels
                    x_fft    = gx_padded{scale_distance+s,c}{ov};
                    x_fft_J  = convolutions.optima_fft(x_fft, J_fft_s, shift_size, avoid_circshift_fft);
                    x_fft_W  = convolutions.optima_fft(x_fft, W_fft_s, shift_size, avoid_circshift_fft);
                    x_ee_oc(:,:,c,s,ov) = x_fft_J(cols, rows);
                    y_ie_oc(:,:,c,s,ov) = x_fft_W(cols, rows);
                end
            else
                for c=1:n_channels
                    % TODO why is gx_padded size not the same in FFT?
                    x    = gx_padded{scale_distance+s}(:,:,c,ov);
                    x_J  = convolutions.optima(x, J_fft_s, shift_size, 1, avoid_circshift_fft);
                    x_W  = convolutions.optima(x, W_fft_s, shift_size, 1, avoid_circshift_fft);
                    x_ee_oc(:,:,c,s,ov) = x_J(cols, rows);
                    y_ie_oc(:,:,c,s,ov) = x_W(cols, rows);
                end
            end
        end
    end
    x_ee_oc = sum(x_ee_oc, 5);
    y_ie_oc = sum(y_ie_oc, 5);
end