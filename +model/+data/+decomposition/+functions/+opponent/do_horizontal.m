function RGBY_h = do_horizontal(rgb, config)
%DO_HORIZONTAL Double Opponent (Horizontal) Decomposition
%   Decomposes the RGB image into it's RGBY horizontal opponent components.
%
%   Input
%       rgb:    the original rgb image
%       config: the model configuration
%   Output
%       RGBY_h: the horizontal opponent color components in the format
%               RGBY_h(column, row, color, scale)

    RGBY_h = zeros(size(rgb,1), size(rgb,2), 4, config.wave.n_scales);
    
    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    for scale=1:config.wave.n_scales
        [r_l_c, r_r_c] = left_right_center(r, scale, config);
        [g_l_c, g_r_c] = left_right_center(g, scale, config);
        [b_l_c, b_r_c] = left_right_center(b, scale, config);

        [r_l_s, r_r_s] = left_right_surround(r, scale, config);
        [g_l_s, g_r_s] = left_right_surround(g, scale, config);
        [b_l_s, b_r_s] = left_right_surround(b, scale, config);

        rgb_l_c = cat(3, r_l_c, g_l_c, b_l_c);
        rgb_r_c = cat(3, r_r_c, g_r_c, b_r_c);
        
        rgb_l_s = cat(3, r_l_s, g_l_s, b_l_s);
        rgb_r_s = cat(3, r_r_s, g_r_s, b_r_s);
        
        RGBY_l = model.data.color.rgb2rgby(rgb_l_c, rgb_r_s);
        RGBY_r = model.data.color.rgb2rgby(rgb_r_c, rgb_l_s);
        
        R_l = RGBY_l(:,:,1);
        G_l = RGBY_l(:,:,2);
        B_l = RGBY_l(:,:,3);
        Y_l = RGBY_l(:,:,4);

        R_r = RGBY_r(:,:,1);
        G_r = RGBY_r(:,:,2);
        B_r = RGBY_r(:,:,3);
        Y_r = RGBY_r(:,:,4);

        % Consolidate to get all horizontal color opponency..
        % TODO average? sum?
        R_h = max(R_l, R_r);
        G_h = max(G_l, G_r);
        B_h = max(B_l, B_r);
        Y_h = max(Y_l, Y_r);

        RGBY_h(:,:,1,scale) = R_h;
        RGBY_h(:,:,2,scale) = G_h;
        RGBY_h(:,:,3,scale) = B_h;
        RGBY_h(:,:,4,scale) = Y_h;
    end
end

function [l_center, r_center] = left_right_center(color, scale, config)
    l_center = model.data.utils.on(apply_left_excitatory_filter(color, scale, config));
    r_center = model.data.utils.on(apply_right_excitatory_filter(color, scale, config));
end

function [l_surround, r_surround] = left_right_surround(color, scale, config)
    l_surround = model.data.utils.off(apply_left_inhibitory_filter(color, scale, config));
    r_surround = model.data.utils.off(apply_right_inhibitory_filter(color, scale, config));
end

function out = apply_left_excitatory_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.center_middle_left(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.center_middle_right(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter);
end

function out = apply_right_excitatory_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.center_middle_right(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.center_middle_left(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter);
end

function out = apply_left_inhibitory_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.surround_middle_left(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.surround_middle_right(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter);
end

function out = apply_right_inhibitory_filter(color, scale, config)
    filter =   model.data.decomposition.functions.opponent.rf.oriented.surround_middle_right(scale, config) ...
             - model.data.decomposition.functions.opponent.rf.oriented.surround_middle_left(scale, config);
    out = model.data.convolutions.optimal_padded(color, filter);
end