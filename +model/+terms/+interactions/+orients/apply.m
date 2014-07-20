function interaction = apply(gx_padded, filter_fft, scale_interactions, config)
% Apply orientation filter (J or W) to get excitation-excitation/inhibition
% interactions between orientations.
%
%   The filter is expected to be the J or W struct array in Fourier space.
%   It is applied to the gx input (padded to avoid edge effects) with
%   respect to the central orientation (oc).
%   If config.compute.use_fft is true, gx_padded is expected to be in
%   Fourier space also. This reduces computation time.

    % TODO why do orientation interactions need scale interaction params??
    scale_deltas        = scale_interactions.deltas;
    scale_distance      = scale_interactions.distance;
    half_size_filter    = scale_interactions.filter_half_size;
    
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    
    interaction = model.utils.zeros(config);
    if ~config.zli.interaction.orient.enabled
        for oc=1:n_orients  % for each central (reference) orientation
            oc_interactions = model.utils.zeros(config);
            for ov=1:n_orients  % for all orientations
                for s=1:n_scales
                    for c=1:n_channels
                        gx = gx_padded{scale_distance+s}(:,:,c,ov);
                        oc_interactions(:,:,c,s,ov) = extract_center(gx, scale_deltas(s), config);
                    end
                end
            end
            interaction(:,:,:,:,oc) = sum(oc_interactions, 5);
        end
    else
        for oc=1:n_orients  % for each central (reference) orientation
            oc_interactions = model.utils.zeros(config);
            for ov=1:n_orients  % for all orientations
                for s=1:n_scales
                    shift_size   = half_size_filter{s};
                    filter_fft_s = filter_fft{s}(:,:,1,ov,oc); % TODO last filter seems to always be 0???
                    if config.zli.interaction.color.enabled
                        % TODO filters can be initialized in n-dimensions
                        filter_fft_s = repmat(filter_fft_s, [1, 1, n_channels]);
                        gx = gx_padded{scale_distance+s}(:,:,:,ov);
                        gx_filtered = apply_filter(gx, filter_fft_s, shift_size, config);
                        oc_interactions(:,:,:,s,ov) = extract_center(gx_filtered, scale_deltas(s), config);
                    else
                        for c=1:n_channels
                            gx = gx_padded{scale_distance+s}(:,:,c,ov);
                            gx_filtered = apply_filter(gx, filter_fft_s, shift_size, config);
                            oc_interactions(:,:,c,s,ov) = extract_center(gx_filtered, scale_deltas(s), config);
                        end
                    end
                end
            end
            interaction(:,:,:,:,oc) = sum(oc_interactions, 5);
        end
    end
end

function gx_filtered = apply_filter(gx, filter_fft_s, shift_size, config)
% Apply the FFT filter (J or W) to gx to get it's interactions.
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    if config.compute.use_fft
        % gx is already in Fourier space
        gx_filtered = model.data.convolutions.optima_fft(gx, filter_fft_s, shift_size, avoid_circshift_fft);
    else
        % gx is in the real data space
        gx_filtered = model.data.convolutions.optima(gx, filter_fft_s, shift_size, 1, avoid_circshift_fft);
    end
end

function center = extract_center(padded, scale_delta_s, config)
% Remove the padding added to the outside of each image.
    n_cols = config.image.width;
    n_rows = config.image.height;
    cols   = scale_delta_s+1 : scale_delta_s+n_cols;
    rows   = scale_delta_s+1 : scale_delta_s+n_rows;
    center = padded(cols, rows, :);
end