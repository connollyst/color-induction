function [newgx_toroidal_x, newgy_toroidal_y, restr_newgx_toroidal_x, restr_newgy_toroidal_y] = add_padding(x, y, Delta, interactions, config)
%ADD_PADDING Add padding to prevent edge effects.

    [toroidal_x, toroidal_y] = mirror_boundry(x, y, Delta, interactions, config);
    
    [newgx_toroidal_x, newgy_toroidal_y] = ...
        do_something(toroidal_x, toroidal_y, Delta, interactions, config);

    [restr_newgx_toroidal_x, restr_newgy_toroidal_y] = ...
        restructure_output(newgx_toroidal_x, newgy_toroidal_y, interactions, config);
end

function [toroidal_x, toroidal_y] = mirror_boundry(x, y, Delta, interactions, config)

    n_scales                 = config.wave.n_scales;
    scale_distance           = interactions.scale_distance;
    n_scale_interactions     = interactions.n_scale_interactions;
    
    toroidal_x = cell(n_scale_interactions, 1);
    toroidal_y = cell(n_scale_interactions, 1);
    for s=1:n_scales
        % mirror boundary condition
        toroidal_x{s+scale_distance} = padarray(x(:,:,:,s,:), [Delta(s),Delta(s),0], 'symmetric');
        toroidal_y{s+scale_distance} = padarray(y(:,:,:,s,:), [Delta(s),Delta(s),0], 'symmetric');
    end
end

function [newgx_toroidal_x, newgy_toroidal_y] = do_something(toroidal_x, toroidal_y, Delta, interactions, config)
    n_cols                   = config.image.width;
    n_rows                   = config.image.height;
    n_scales                 = config.wave.n_scales;
    scale_distance           = interactions.scale_distance;
    border_weight            = interactions.border_weight;
    n_scale_interactions     = interactions.n_scale_interactions;
    
    newgx_toroidal_x       = cell(n_scale_interactions, 1);
    newgy_toroidal_y       = cell(n_scale_interactions, 1);
    for s=1:n_scale_interactions
        newgx_toroidal_x{s} = model.terms.gx(toroidal_x{s});
        newgy_toroidal_y{s} = model.terms.gy(toroidal_y{s});
    end

    kk_tmp1_x                = zeros(size(toroidal_x{scale_distance+1})); 
    kk_tmp2_x                = zeros(size(toroidal_x{n_scales+scale_distance}));
    kk_tmp1_y                = zeros(size(toroidal_y{scale_distance+1})); 
    kk_tmp2_y                = zeros(size(toroidal_y{n_scales+scale_distance}));
    % .. what sorcery is this?
    for i=1:scale_distance+1
        cols      = Delta(1)+1:Delta(1)+n_cols;
        rows      = Delta(1)+1:Delta(1)+n_rows;
        i_cols    = Delta(i)+1:Delta(i)+n_cols;
        i_rows    = Delta(i)+1:Delta(i)+n_rows;
        s_cols    = Delta(n_scales)+1:Delta(n_scales)+n_cols;
        s_rows    = Delta(n_scales)+1:Delta(n_scales)+n_rows;
        si_cols   = Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+n_cols;
        si_rows   = Delta(n_scales-i+1)+1:Delta(n_scales-i+1)+n_rows;
        radius_i  = scale_distance+i;
        radius_si = n_scales+scale_distance-(i-1);
        kk_tmp1_x(cols,rows,:)     = kk_tmp1_x(cols,rows,:)     + border_weight(i) * newgx_toroidal_x{radius_i}(i_cols,i_rows,:);
        kk_tmp1_y(cols,rows,:)     = kk_tmp1_y(cols,rows,:)     + border_weight(i) * newgy_toroidal_y{radius_i}(i_cols,i_rows,:);
        kk_tmp2_x(s_cols,s_rows,:) = kk_tmp2_x(s_cols,s_rows,:) + border_weight(i) * newgx_toroidal_x{radius_si}(si_cols,si_rows,:);
        kk_tmp2_y(s_cols,s_rows,:) = kk_tmp2_y(s_cols,s_rows,:) + border_weight(i) * newgy_toroidal_y{radius_si}(si_cols,si_rows,:);
    end

    newgx_toroidal_x{1:scale_distance} = kk_tmp1_x;
    newgy_toroidal_y{1:scale_distance} = kk_tmp1_y;
    newgx_toroidal_x{n_scales+scale_distance+1:n_scale_interactions} = kk_tmp2_x;
    newgy_toroidal_y{n_scales+scale_distance+1:n_scale_interactions} = kk_tmp2_y;
end

function [restr_newgx_toroidal_x, restr_newgy_toroidal_y] = restructure_output(newgx_toroidal_x, newgy_toroidal_y, interactions, config)
    n_cols                   = config.image.width;
    n_rows                   = config.image.height;
    n_channels               = config.image.n_channels;
    n_orients                = config.wave.n_orients;
    Delta_ext                = interactions.Delta_ext;
    n_scale_interactions     = interactions.n_scale_interactions;
    restr_newgx_toroidal_x   = zeros(n_cols, n_rows, n_channels, n_scale_interactions, n_orients);
    restr_newgy_toroidal_y   = zeros(n_cols, n_rows, n_channels, n_scale_interactions, n_orients);
    for s=1:n_scale_interactions
        cols = Delta_ext(s)+1 : Delta_ext(s)+n_cols;
        rows = Delta_ext(s)+1 : Delta_ext(s)+n_rows;
        restr_newgx_toroidal_x(:,:,:,s,:) = newgx_toroidal_x{s}(cols, rows, :, :);
        restr_newgy_toroidal_y(:,:,:,s,:) = newgy_toroidal_y{s}(cols, rows, :, :);
    end
end
