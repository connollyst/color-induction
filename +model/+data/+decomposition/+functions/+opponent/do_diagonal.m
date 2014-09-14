function LDRGBY_d = do_diagonal(rgb, config)
%DO_DIAGONAL Double Opponent (Diagonal) Decomposition
%   Decomposes the RGB image into it's RGBY diagonal opponent components.
%
%   Input
%       rgb:        the original rgb image
%       config:     the model configuration
%   Output
%       LDRGBY_d:   the diagonal opponent color components in the format
%                   LDRGBY_d(column, row, color, scale)
    rgb = im2double(rgb);
    LDRGBY_d = zeros(size(rgb,1), size(rgb,2), 6, config.wave.n_scales);
    for scale=1:config.wave.n_scales
        LDRGBY_tl2br = model.data.decomposition.functions.opponent.rf.utils.filter(rgb, ...
                            tl2br_filter_ON(scale, config), ...
                            tl2br_filter_OFF(scale, config) ...
                       );
        LDRGBY_br2tl = model.data.decomposition.functions.opponent.rf.utils.filter(rgb, ...
                            br2tl_filter_ON(scale, config), ...
                            br2tl_filter_OFF(scale, config) ...
                       );
        LDRGBY_bl2tr = model.data.decomposition.functions.opponent.rf.utils.filter(rgb, ...
                            bl2tr_filter_ON(scale, config), ...
                            bl2tr_filter_OFF(scale, config) ...
                       );
        LDRGBY_tr2bl = model.data.decomposition.functions.opponent.rf.utils.filter(rgb, ...
                            tr2bl_filter_ON(scale, config), ...
                            tr2bl_filter_OFF(scale, config) ...
                       );
        LDRGBY_d(:,:,:,scale) = max(max(max(LDRGBY_tl2br, LDRGBY_br2tl), LDRGBY_bl2tr), LDRGBY_tr2bl);
    end
end

%% FILTERS

function f = tl2br_filter_ON(scale, config)
    f =   model.data.decomposition.functions.opponent.rf.oriented.center_top_left(scale, config) ...
        - model.data.decomposition.functions.opponent.rf.oriented.center_bottom_right(scale, config);
end

function f = br2tl_filter_ON(scale, config)
    f =   model.data.decomposition.functions.opponent.rf.oriented.center_bottom_right(scale, config) ...
        - model.data.decomposition.functions.opponent.rf.oriented.center_top_left(scale, config);
end

function f = bl2tr_filter_ON(scale, config)
    f =   model.data.decomposition.functions.opponent.rf.oriented.center_bottom_left(scale, config) ...
        - model.data.decomposition.functions.opponent.rf.oriented.center_top_right(scale, config);
end

function f = tr2bl_filter_ON(scale, config)
    f =   model.data.decomposition.functions.opponent.rf.oriented.center_top_right(scale, config) ...
        - model.data.decomposition.functions.opponent.rf.oriented.center_bottom_left(scale, config);
end

function f = tl2br_filter_OFF(scale, config)
    f =   model.data.decomposition.functions.opponent.rf.oriented.surround_top_left(scale, config) ...
        - model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_right(scale, config);
end

function f = br2tl_filter_OFF(scale, config)
    f =   model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_right(scale, config) ...
        - model.data.decomposition.functions.opponent.rf.oriented.surround_top_left(scale, config);
end

function f = bl2tr_filter_OFF(scale, config)
    f =   model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_left(scale, config) ...
        - model.data.decomposition.functions.opponent.rf.oriented.surround_top_right(scale, config);
end

function f = tr2bl_filter_OFF(scale, config)
    f =   model.data.decomposition.functions.opponent.rf.oriented.surround_top_right(scale, config) ...
        - model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_left(scale, config);
end