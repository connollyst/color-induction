function interaction = apply_filter(data, filter_fft, interactions, config)
% Apply orientation filter (J or W) to get excitation-excitation/inhibition
% interactions between orientations.
%
%   The filter is expected to be the J or W struct array in Fourier space
%   & is applied to the data input with respect to the central orientation.

    data_padded = model.data.padding.add.orient(data, interactions.scale, config);
    if config.zli.interaction.orient.enabled && config.compute.use_fft
        data_padded = apply_fft(data_padded);
    end

    % TODO orientation interactions don't need to add extra scales!
    scale_deltas        = interactions.scale.deltas;
    scale_distance      = interactions.scale.distance;
    half_size_filter    = interactions.scale.filter_half_size;
    
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    
    interaction = model.utils.zeros(config);
    if ~config.zli.interaction.orient.enabled
        % TODO dont add padding in the first place!
        interaction = data;
    else
        for oc=1:n_orients  % for each central (reference) orientation
            oc_interactions = model.utils.zeros(config);
            for ov=1:n_orients  % for all orientations
                for s=1:n_scales
                    shift_size   = half_size_filter{s};
                    filter_fft_s = filter_fft{s}(:,:,1,ov,oc); % TODO last filter seems to always be 0???
                    for c=1:n_channels
                        data = data_padded{scale_distance+s}(:,:,c,ov);
                        data_filtered = filter_data(data, filter_fft_s, shift_size, config);
                        oc_interactions(:,:,c,s,ov) = extract_center(data_filtered, scale_deltas(s), config);
                    end
                end
            end
            interaction(:,:,:,:,oc) = sum(oc_interactions, 5);
        end
    end
end

function data_padded_fft = apply_fft(data_padded)
% Preprocess the input data to Fourier space for faster convolutions.
    data_padded_fft = cell(size(data_padded));
    for s=1:length(data_padded)
        data_padded_fft{s} = zeros(size(data_padded{s}));
        n_channels       = size(data_padded{s}, 3);
        n_orients        = size(data_padded{s}, 5);
        for c=1:n_channels
            for o=1:n_orients
                data_padded_fft{s}(:,:,c,1,o) = fftn(data_padded{s}(:,:,c,1,o));
            end
        end
    end
end

function data_filtered = filter_data(data, filter_fft_s, shift_size, config)
% Apply the FFT filter (J or W) to data to get it's interactions.
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    if config.compute.use_fft
        % data is already in Fourier space
        data_filtered = model.data.convolutions.optima_fft(data, filter_fft_s, shift_size, avoid_circshift_fft);
    else
        % data is in the real data space
        data_filtered = model.data.convolutions.optima(data, filter_fft_s, shift_size, 1, avoid_circshift_fft);
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