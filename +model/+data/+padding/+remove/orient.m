function data = orient(data_padded, scale_interactions, config)

    scale_deltas   = scale_interactions.deltas;
    scale_distance = scale_interactions.distance;

    n_channels     = config.image.n_channels;
    n_scales       = config.wave.n_scales;
    n_orients      = config.wave.n_orients;

    data           = model.utils.zeros(config);
    for oc=1:n_orients  % for each central (reference) orientation
        oc_interactions = model.utils.zeros(config);
        for ov=1:n_orients  % for all orientations
            for s=1:n_scales
                for c=1:n_channels
                    data_padded_s = data_padded{scale_distance+s}(:,:,c,ov);
                    oc_interactions(:,:,c,s,ov) = extract_center(data_padded_s, scale_deltas(s), config);
                end
            end
        end
        data(:,:,:,:,oc) = sum(oc_interactions, 5);
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