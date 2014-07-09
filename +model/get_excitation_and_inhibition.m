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

    for oc=1:n_orients  % loop over the central (reference) orientation
        x_ei(:,:,:,:,oc)   = model.terms.x_ei(oc, gy, interactions, config);
        [x_ee_oc, y_ie_oc] = model.terms.x_ee_y_ie(oc, gx_padded, JW, interactions, config);
        x_ee(:,:,:,:,oc)   = x_ee_oc;
        y_ie(:,:,:,:,oc)   = y_ie_oc;
    end
    
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

