function LDRGBY_v = do_vertical_old(rgb, config)
%DO_VERTICAL Double Opponent (Vertical) Decomposition
%   Decomposes the RGB image into it's RGBY vertical opponent components.
%
%   Input
%       rgb:      the original rgb image
%       config:   the model configuration
%   Output
%       LDRGBY_h: the vertical opponent color components in the format
%                 LDRGBY_v(column, row, color, scale)

    LDRGBY_v = zeros(size(rgb,1), size(rgb,2), 4, config.wave.n_scales);
    
    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    for scale=1:config.wave.n_scales
        [r_t_c, r_b_c] = top_bottom_center(r, scale, config);
        [g_t_c, g_b_c] = top_bottom_center(g, scale, config);
        [b_t_c, b_b_c] = top_bottom_center(b, scale, config);

        [r_t_s, r_b_s] = top_bottom_surround(r, scale, config);
        [g_t_s, g_b_s] = top_bottom_surround(g, scale, config);
        [b_t_s, b_b_s] = top_bottom_surround(b, scale, config);

        rgb_t_c = cat(3, r_t_c, g_t_c, b_t_c);
        rgb_b_c = cat(3, r_b_c, g_b_c, b_b_c);
        
        rgb_t_s = cat(3, r_t_s, g_t_s, b_t_s);
        rgb_b_s = cat(3, r_b_s, g_b_s, b_b_s);
        
        LDRGBY_t = model.data.color.rgb2itti(rgb_t_c, rgb_b_s);
        LDRGBY_b = model.data.color.rgb2itti(rgb_b_c, rgb_t_s);
        
        L_t = LDRGBY_t(:,:,1);
        D_t = LDRGBY_t(:,:,2);
        R_t = LDRGBY_t(:,:,3);
        G_t = LDRGBY_t(:,:,4);
        B_t = LDRGBY_t(:,:,5);
        Y_t = LDRGBY_t(:,:,6);

        L_b = LDRGBY_b(:,:,1);
        D_b = LDRGBY_b(:,:,2);
        R_b = LDRGBY_b(:,:,3);
        G_b = LDRGBY_b(:,:,4);
        B_b = LDRGBY_b(:,:,5);
        Y_b = LDRGBY_b(:,:,6);

        % Consolidate to get all vertical color opponency..
        % TODO average? sum?
        L_v = max(L_t, L_b);
        D_v = max(D_t, D_b);
        R_v = max(R_t, R_b);
        G_v = max(G_t, G_b);
        B_v = max(B_t, B_b);
        Y_v = max(Y_t, Y_b);

        LDRGBY_v(:,:,1,scale) = L_v;
        LDRGBY_v(:,:,2,scale) = D_v;
        LDRGBY_v(:,:,3,scale) = R_v;
        LDRGBY_v(:,:,4,scale) = G_v;
        LDRGBY_v(:,:,5,scale) = B_v;
        LDRGBY_v(:,:,6,scale) = Y_v;
    end
end

function [t_center, b_center] = top_bottom_center(color, scale, config)
    t_center = model.data.utils.on(apply_top_center_filter(color, scale, config));
    b_center = model.data.utils.on(apply_bottom_center_filter(color, scale, config));
end

function [t_surround, b_surround] = top_bottom_surround(color, scale, config)
    t_surround = model.data.utils.off(apply_top_surround_filter(color, scale, config));
    b_surround = model.data.utils.off(apply_bottom_surround_filter(color, scale, config));
end

function out = apply_top_center_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.center_top_middle(scale, config)      ...
             - model.data.decomposition.functions.opponent.rf.oriented.center_bottom_middle(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_bottom_center_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.center_bottom_middle(scale, config)   ...
             - model.data.decomposition.functions.opponent.rf.oriented.center_top_middle(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_top_surround_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.surround_top_middle(scale, config)    ...
             - model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_middle(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_bottom_surround_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.surround_bottom_middle(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.surround_top_middle(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end