function RGBY_v = do_vertical(rgb, config)
%DO_VERTICAL Double Opponent (Vertical) Decomposition
%   Decomposes the RGB image into it's RGBY vertical opponent components.
%
%   Input
%       rgb:    the original rgb image
%       config: the model configuration
%   Output
%       RGBY_h: the vertical opponent color components in the format
%               RGBY_h(column, row, color, scale)

    RGBY_v = zeros(size(rgb,1), size(rgb,2), 4, config.wave.n_scales);
    
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

        % Combine center surround signals to obtain color opponency..
        R_t = model.data.utils.on(r_t_c - (g_b_s + b_b_s)/2);
        G_t = model.data.utils.on(g_t_c - (r_b_s + b_b_s)/2);
        B_t = model.data.utils.on(b_t_c - (r_b_s + g_b_s)/2);
        Y_t = model.data.utils.on((r_t_c + g_t_c)/2 - abs(r_b_s - g_b_s)/2 - b_b_s);

        R_b = model.data.utils.on(r_b_c - (g_t_s + b_t_s)/2);
        G_b = model.data.utils.on(g_b_c - (r_t_s + b_t_s)/2);
        B_b = model.data.utils.on(b_b_c - (r_t_s + g_t_s)/2);
        Y_b = model.data.utils.on((r_b_c + g_b_c)/2 - abs(r_t_s - g_t_s)/2 - b_t_s);

        % Consolidate to get all vertical color opponency..
        % TODO average? sum?
        R_v = max(R_t, R_b);
        G_v = max(G_t, G_b);
        B_v = max(B_t, B_b);
        Y_v = max(Y_t, Y_b);

        RGBY_v(:,:,1,scale) = R_v;
        RGBY_v(:,:,2,scale) = G_v;
        RGBY_v(:,:,3,scale) = B_v;
        RGBY_v(:,:,4,scale) = Y_v;
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
    filter =   model.data.wavelet.functions.opponent.rf.oriented.center_top_middle(scale, config)      ...
             - model.data.wavelet.functions.opponent.rf.oriented.center_bottom_middle(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_bottom_center_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.center_bottom_middle(scale, config)   ...
             - model.data.wavelet.functions.opponent.rf.oriented.center_top_middle(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_top_surround_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.surround_top_middle(scale, config)    ...
             - model.data.wavelet.functions.opponent.rf.oriented.surround_bottom_middle(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end

function out = apply_bottom_surround_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.surround_bottom_middle(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.surround_top_middle(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter());
end