function [gx_padded, gy_padded, gx, gy] = add_padding(x, y, interactions, config)
%ADD_PADDING Add padding to prevent edge effects.
%   TODO Move intermediate interaction scales to another function

    [ x_padded,  y_padded] = mirror_boundary(x, y, interactions, config);
    [gx_padded, gy_padded] = do_something(x_padded, y_padded, interactions, config);
    [gx,        gy]        = get_toroidal_centers(gx_padded, gy_padded, interactions, config);
end

function [x_toroidal, y_toroidal] = mirror_boundary(x, y, interactions, config)
%MIRROR_BOUNDARY Mirror the edges of the data to prevent edge effects.

    n_scales             = config.wave.n_scales;
    scale_deltas         = config.wave.scale_deltas;
    scale_distance       = interactions.scale_distance;
    n_scale_interactions = interactions.n_scale_interactions;
    
    x_toroidal = cell(n_scale_interactions, 1);
    y_toroidal = cell(n_scale_interactions, 1);
    for s=1:n_scales
        scale_delta = scale_deltas(s);
        x_toroidal{s+scale_distance} = padarray(x(:,:,:,s,:), [scale_delta,scale_delta,0], 'symmetric');
        y_toroidal{s+scale_distance} = padarray(y(:,:,:,s,:), [scale_delta,scale_delta,0], 'symmetric');
    end
end

function [gx_toroidal, gy_toroidal] = do_something(x_toroidal, y_toroidal, interactions, config)
%DO_SOMETHING ..what sorcery is this?

    n_cols               = config.image.width;
    n_rows               = config.image.height;
    n_scales             = config.wave.n_scales;
    scale_deltas         = config.wave.scale_deltas;
    scale_distance       = interactions.scale_distance;
    border_weight        = interactions.border_weight;
    n_scale_interactions = interactions.n_scale_interactions;
    
    gx_toroidal = cell(n_scale_interactions, 1);
    gy_toroidal = cell(n_scale_interactions, 1);
    for s=1:n_scale_interactions
        % TODO its better to convert to gx/gy before mirror_boundary()!
        gx_toroidal{s} = model.terms.gx(x_toroidal{s});
        gy_toroidal{s} = model.terms.gy(y_toroidal{s});
    end

    kk_tmp1_x = zeros(size(x_toroidal{scale_distance+1})); 
    kk_tmp2_x = zeros(size(x_toroidal{n_scales+scale_distance}));
    kk_tmp1_y = zeros(size(y_toroidal{scale_distance+1})); 
    kk_tmp2_y = zeros(size(y_toroidal{n_scales+scale_distance}));
    
    for i=1:scale_distance+1
        cols      = scale_deltas(1)+1:scale_deltas(1)+n_cols;
        rows      = scale_deltas(1)+1:scale_deltas(1)+n_rows;
        i_cols    = scale_deltas(i)+1:scale_deltas(i)+n_cols;
        i_rows    = scale_deltas(i)+1:scale_deltas(i)+n_rows;
        s_cols    = scale_deltas(n_scales)+1:scale_deltas(n_scales)+n_cols;
        s_rows    = scale_deltas(n_scales)+1:scale_deltas(n_scales)+n_rows;
        si_cols   = scale_deltas(n_scales-i+1)+1:scale_deltas(n_scales-i+1)+n_cols;
        si_rows   = scale_deltas(n_scales-i+1)+1:scale_deltas(n_scales-i+1)+n_rows;
        radius_i  = scale_distance+i;
        radius_si = n_scales+scale_distance-(i-1);
        kk_tmp1_x(cols,rows,:)     = kk_tmp1_x(cols,rows,:)     + border_weight(i) * gx_toroidal{radius_i}(i_cols,i_rows,:);
        kk_tmp1_y(cols,rows,:)     = kk_tmp1_y(cols,rows,:)     + border_weight(i) * gy_toroidal{radius_i}(i_cols,i_rows,:);
        kk_tmp2_x(s_cols,s_rows,:) = kk_tmp2_x(s_cols,s_rows,:) + border_weight(i) * gx_toroidal{radius_si}(si_cols,si_rows,:);
        kk_tmp2_y(s_cols,s_rows,:) = kk_tmp2_y(s_cols,s_rows,:) + border_weight(i) * gy_toroidal{radius_si}(si_cols,si_rows,:);
    end

    gx_toroidal{1:scale_distance} = kk_tmp1_x;
    gy_toroidal{1:scale_distance} = kk_tmp1_y;
    gx_toroidal{n_scales+scale_distance+1:n_scale_interactions} = kk_tmp2_x;
    gy_toroidal{n_scales+scale_distance+1:n_scale_interactions} = kk_tmp2_y;
end

function [gx, gy] = get_toroidal_centers(gx_toroidal, gy_toroidal, interactions, config)
%GET_TOROIDAL_CENTERS Extract the centers of the padded image
%   TODO: How is this different than just calling model.terms.gx on the
%         original input?

    n_cols               = config.image.width;
    n_rows               = config.image.height;
    n_channels           = config.image.n_channels;
    n_orients            = config.wave.n_orients;
    n_scale_interactions = interactions.n_scale_interactions;
    
    gx = zeros(n_cols, n_rows, n_channels, n_scale_interactions, n_orients);
    gy = zeros(n_cols, n_rows, n_channels, n_scale_interactions, n_orients);
    for s=1:n_scale_interactions
        gx(:,:,:,s,:) = extract_center(gx_toroidal, s, interactions, config);
        gy(:,:,:,s,:) = extract_center(gy_toroidal, s, interactions, config);
    end
end

function center = extract_center(toroidal, i, interactions, config)
%EXTRACT_CENTER Recovers the original from the center of the padded image.

    n_cols    = config.image.width;
    n_rows    = config.image.height;
    Delta_ext = interactions.Delta_ext;
    cols      = Delta_ext(i)+1 : Delta_ext(i)+n_cols;
    rows      = Delta_ext(i)+1 : Delta_ext(i)+n_rows;
    center    = toroidal{i}(cols, rows, :, :);
end
