function center = remove_padding(padded, interactions, config)
%GET_TOROIDAL_CENTERS Extract the centers of the padded image.

    n_cols               = config.image.width;
    n_rows               = config.image.height;
    n_channels           = config.image.n_channels;
    n_orients            = config.wave.n_orients;
    n_scale_interactions = interactions.n_scale_interactions;
    
    center = zeros(n_cols, n_rows, n_channels, n_scale_interactions, n_orients);
    for s=1:n_scale_interactions
        center(:,:,:,s,:) = extract_center(padded, s, interactions, config);
    end
end

function center = extract_center(padded, s, interactions, config)
%EXTRACT_CENTER Recovers the original from the center of the padded image.
%   Note: the padded data is in a struct array, while the recovered centers
%         are returned in a matrix.

    n_cols    = config.image.width;
    n_rows    = config.image.height;
    Delta_ext = interactions.Delta_ext;
    
    cols   = Delta_ext(s)+1 : Delta_ext(s)+n_cols;
    rows   = Delta_ext(s)+1 : Delta_ext(s)+n_rows;
    center = padded{s}(cols, rows, :, :);
end