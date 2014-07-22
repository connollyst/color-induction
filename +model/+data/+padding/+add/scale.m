function gx_padded = scale(x, scale_interactions, config)
%PADDING.ADD Add padding to prevent edge effects.
    x_padded  = mirror_boundary(x, scale_interactions, config);
    gx_padded = do_something(x_padded, scale_interactions, config);
end

function [x_toroidal, y_toroidal] = mirror_boundary(x, scale_interactions, config)
%MIRROR_BOUNDARY Mirror the edges of the data to prevent edge effects.
    n_scales             = config.wave.n_scales;
    scale_deltas         = scale_interactions.deltas;
    scale_distance       = scale_interactions.distance;
    n_scale_interactions = scale_interactions.n_interactions;
    
    x_toroidal = cell(n_scale_interactions, 1);
    y_toroidal = cell(n_scale_interactions, 1);
    for s=1:n_scales
        scale_delta = scale_deltas(s);
        x_toroidal{s+scale_distance} = padarray(x(:,:,:,s,:), [scale_delta,scale_delta,0], 'symmetric');
    end
end

function x_toroidal = do_something(x_toroidal, scale_interactions, config)
%DO_SOMETHING ..what sorcery is this?
    n_cols               = config.image.width;
    n_rows               = config.image.height;
    n_scales             = config.wave.n_scales;
    scale_deltas         = scale_interactions.deltas;
    scale_distance       = scale_interactions.distance;
    border_weight        = scale_interactions.border_weight;
    n_scale_interactions = scale_interactions.n_interactions;
    
    kk_tmp1_x = zeros(size(x_toroidal{scale_distance+1})); 
    kk_tmp2_x = zeros(size(x_toroidal{n_scales+scale_distance}));
    
    for i=1:scale_distance+1
        cols      = scale_deltas(1)+1            : scale_deltas(1)+n_cols;
        rows      = scale_deltas(1)+1            : scale_deltas(1)+n_rows;
        i_cols    = scale_deltas(i)+1            : scale_deltas(i)+n_cols;
        i_rows    = scale_deltas(i)+1            : scale_deltas(i)+n_rows;
        s_cols    = scale_deltas(n_scales)+1     : scale_deltas(n_scales)+n_cols;
        s_rows    = scale_deltas(n_scales)+1     : scale_deltas(n_scales)+n_rows;
        si_cols   = scale_deltas(n_scales-i+1)+1 : scale_deltas(n_scales-i+1)+n_cols;
        si_rows   = scale_deltas(n_scales-i+1)+1 : scale_deltas(n_scales-i+1)+n_rows;
        radius_i  = scale_distance+i;
        radius_si = n_scales+scale_distance-(i-1);
        kk_tmp1_x(cols,rows,:)     = kk_tmp1_x(cols,rows,:)     + border_weight(i) * x_toroidal{radius_i}(i_cols,i_rows,:);
        kk_tmp2_x(s_cols,s_rows,:) = kk_tmp2_x(s_cols,s_rows,:) + border_weight(i) * x_toroidal{radius_si}(si_cols,si_rows,:);
    end

    x_toroidal{1:scale_distance} = kk_tmp1_x;
    x_toroidal{n_scales+scale_distance+1:n_scale_interactions} = kk_tmp2_x;
end