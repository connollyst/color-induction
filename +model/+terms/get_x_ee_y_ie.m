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

    if config.compute.use_fft
        gx_padded = to_fft(gx_padded);
    end
    
    % First apply orientation interactions
    x_ee = get_orientation_interactions(gx_padded, JW.J_fft, interactions, config);
    y_ie = get_orientation_interactions(gx_padded, JW.W_fft, interactions, config);
    
    % Then apply scale interactions
    x_ee = get_scale_interactions(x_ee, interactions);
    y_ie = get_scale_interactions(y_ie, interactions);
end

function orient_interactions = get_orientation_interactions(gx_padded, filter_fft, interactions, config)
%Apply orientation filter (J or W) to get excitation-excitation/inhibition
%interactions between orientations.
%
%   The filter is expected to be the J or W struct array in Fourier space.
%   It is applied to the gx input (padded to avoid edge effects) with
%   respect to the central orientation (oc).
%   If config.compute.use_fft is true, gx_padded is expected to be in
%   Fourier space also. This reduces computation time.

    half_size_filter    = interactions.half_size_filter;
    scale_distance      = interactions.scale_distance;
    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    use_fft             = config.compute.use_fft;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    
    orient_interactions = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    for oc=1:n_orients  % for each central (reference) orientation
        oc_interactions = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
        for ov=1:n_orients  % for all orientations
            for s=1:n_scales
                filter_fft_s = filter_fft{s}(:,:,1,ov,oc);
                shift_size   = half_size_filter{s};
                for c=1:n_channels % for all color channels
                    gx = gx_padded{scale_distance+s}(:,:,c,ov);
                    if use_fft
                        % gx is already in Fourier space
                        gx_filtered = convolutions.optima_fft(gx, filter_fft_s, shift_size, avoid_circshift_fft);
                    else
                        % gx is in the real data space
                        gx_filtered = convolutions.optima(gx, filter_fft_s, shift_size, 1, avoid_circshift_fft);
                    end
                    oc_interactions(:,:,c,s,ov) = extract_center(gx_filtered, s, config);
                end
            end
        end
        orient_interactions(:,:,:,:,oc) = sum(oc_interactions, 5);
    end
end

function scale_interactions = get_scale_interactions(data, interactions)
%Apply scale filter to get excitation-excitation/inhibition interactions
%between scales.

    scale_filter       = interactions.scale_filter;
    scale_interactions = convolutions.optima(data, scale_filter, 0, 0);
end

function gx_padded_fft = to_fft(gx_padded)
%Preprocess the input data to Fourier space for faster processing.

    gx_padded_fft = cell(size(gx_padded));
    for s=1:length(gx_padded)
        gx_padded_fft{s} = zeros(size(gx_padded{s}));
        n_channels       = size(gx_padded{s}, 3);
        n_orients        = size(gx_padded{s}, 5);
        for c=1:n_channels
            for o=1:n_orients
                gx_padded_fft{s}(:,:,c,1,o) = fftn(gx_padded{s}(:,:,c,1,o));
            end
        end
    end
end

function center = extract_center(padded, s, config)
%Remove the padding added to the outside of each image.

    n_cols       = config.image.width;
    n_rows       = config.image.height;
    scale_deltas = config.wave.scale_deltas;
    
    cols   = scale_deltas(s)+1 : scale_deltas(s)+n_cols;
    rows   = scale_deltas(s)+1 : scale_deltas(s)+n_rows;
    center = padded(cols, rows);
end
