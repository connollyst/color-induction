function RGBY_d = do_diagonal(rgb, config)
%DO_DIAGONAL Double Opponent (Diagonal) Decomposition
%   Decomposes the RGB image into it's RGBY diagonal opponent components.
%
%   Input
%       rgb:    the original rgb image
%       config: the model configuration
%   Output
%       RGBY_h: the diagonal opponent color components in the format
%               RGBY_h(column, row, color, scale)

    RGBY_d = zeros(size(rgb,1), size(rgb,2), 4, config.wave.n_scales);

    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    for scale=1:config.wave.n_scales
        [r_tl_c, r_tr_c, r_br_c, r_bl_c] = centers(r, scale, config);
        [g_tl_c, g_tr_c, g_br_c, g_bl_c] = centers(g, scale, config);
        [b_tl_c, b_tr_c, b_br_c, b_bl_c] = centers(b, scale, config);

        [r_tl_s, r_tr_s, r_br_s, r_bl_s] = surrounds(r, scale, config);
        [g_tl_s, g_tr_s, g_br_s, g_bl_s] = surrounds(g, scale, config);
        [b_tl_s, b_tr_s, b_br_s, b_bl_s] = surrounds(b, scale, config);

        rgb_tl_c = cat(3, r_tl_c, g_tl_c, b_tl_c);
        rgb_tr_c = cat(3, r_tr_c, g_tr_c, b_tr_c);
        rgb_br_c = cat(3, r_br_c, g_br_c, b_br_c);
        rgb_bl_c = cat(3, r_bl_c, g_bl_c, b_bl_c);
        
        rgb_tl_s = cat(3, r_tl_s, g_tl_s, b_tl_s);
        rgb_tr_s = cat(3, r_tr_s, g_tr_s, b_tr_s);
        rgb_br_s = cat(3, r_br_s, g_br_s, b_br_s);
        rgb_bl_s = cat(3, r_bl_s, g_bl_s, b_bl_s);
        
        RGBY_tl = model.data.color.rgb2rgby(rgb_tl_c, rgb_br_s);
        RGBY_tr = model.data.color.rgb2rgby(rgb_tr_c, rgb_bl_s);
        RGBY_br = model.data.color.rgb2rgby(rgb_br_c, rgb_tl_s);
        RGBY_bl = model.data.color.rgb2rgby(rgb_bl_c, rgb_tr_s);
        
        % Combine center surround signals to obtain color opponency..
        % TOP LEFT
        R_tl = RGBY_tl(:,:,1);
        G_tl = RGBY_tl(:,:,2);
        B_tl = RGBY_tl(:,:,3);
        Y_tl = RGBY_tl(:,:,4);
        % TOP RIGHT
        R_tr = RGBY_tr(:,:,1);
        G_tr = RGBY_tr(:,:,2);
        B_tr = RGBY_tr(:,:,3);
        Y_tr = RGBY_tr(:,:,4);
        % BOTTOM RIGHT
        R_br = RGBY_br(:,:,1);
        G_br = RGBY_br(:,:,2);
        B_br = RGBY_br(:,:,3);
        Y_br = RGBY_br(:,:,4);
        % BOTTOM LEFT
        R_bl = RGBY_bl(:,:,1);
        G_bl = RGBY_bl(:,:,2);
        B_bl = RGBY_bl(:,:,3);
        Y_bl = RGBY_bl(:,:,4);

        % Consolidate to get all diagonal color opponency..
        % TODO average? sum?
        R_d = max(max(max(R_tl, R_tr), R_br), R_bl);
        G_d = max(max(max(G_tl, G_tr), G_br), G_bl);
        B_d = max(max(max(B_tl, B_tr), B_br), B_bl);
        Y_d = max(max(max(Y_tl, Y_tr), Y_br), Y_bl);

        RGBY_d(:,:,1,scale) = R_d;
        RGBY_d(:,:,2,scale) = G_d;
        RGBY_d(:,:,3,scale) = B_d;
        RGBY_d(:,:,4,scale) = Y_d;
    end
end

function [tlc, trc, brc, blc] = centers(color, scale, config)
% Returns the top & bottom by left & right centers.
    tlc = model.data.utils.on(apply_top_left_center_filter      (color, scale, config));
    trc = model.data.utils.on(apply_top_right_center_filter     (color, scale, config));
    blc = model.data.utils.on(apply_bottom_left_center_filter   (color, scale, config));
    brc = model.data.utils.on(apply_bottom_right_center_filter  (color, scale, config));
end

function [tls, trs, brs, bls] = surrounds(color, scale, config)
% Returns the top & bottom by left & right surrounds.
    tls = model.data.utils.off(apply_top_left_surround_filter    (color, scale, config));
    trs = model.data.utils.off(apply_top_right_surround_filter   (color, scale, config));
    bls = model.data.utils.off(apply_bottom_left_surround_filter (color, scale, config));
    brs = model.data.utils.off(apply_bottom_right_surround_filter(color, scale, config));
end

function out = apply_top_left_center_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.center_top_left(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.center_bottom_right(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_top_right_center_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.center_top_right(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.center_bottom_left(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_bottom_right_center_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.center_bottom_right(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.center_top_left(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_bottom_left_center_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.center_bottom_left(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.center_top_right(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_top_left_surround_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.surround_top_left(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_right(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_top_right_surround_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.surround_top_right(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_left(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_bottom_right_surround_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_right(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.surround_top_left(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_bottom_left_surround_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_left(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.surround_top_right(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end