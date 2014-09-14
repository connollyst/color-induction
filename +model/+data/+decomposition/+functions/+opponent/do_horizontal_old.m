function LDRGBY_h = do_horizontal_old(rgb, config)
%DO_HORIZONTAL Double Opponent (Horizontal) Decomposition
%   Decomposes the RGB image into it's RGBY horizontal opponent components.
%
%   Input
%       rgb:      the original rgb image
%       config:   the model configuration
%   Output
%       LDRGBY_h: the horizontal opponent color components in the format
%                 LDRGBY_h(column, row, color, scale)

    LDRGBY_h = zeros(size(rgb,1), size(rgb,2), 6, config.wave.n_scales);
    
    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    for scale=1:config.wave.n_scales
        
        [r_l_c, r_r_c] = left_and_right_ON(r, scale, config);
        [g_l_c, g_r_c] = left_and_right_ON(g, scale, config);
        [b_l_c, b_r_c] = left_and_right_ON(b, scale, config);

        [r_l_s, r_r_s] = left_and_right_OFF(r, scale, config);
        [g_l_s, g_r_s] = left_and_right_OFF(g, scale, config);
        [b_l_s, b_r_s] = left_and_right_OFF(b, scale, config);

        rgb_l_c = cat(3, r_l_c, g_l_c, b_l_c);
        rgb_r_c = cat(3, r_r_c, g_r_c, b_r_c);
        
        rgb_l_s = cat(3, r_l_s, g_l_s, b_l_s);
        rgb_r_s = cat(3, r_r_s, g_r_s, b_r_s);
        
        LDRGBY_l = model.data.color.rgb2itti(rgb_l_c, rgb_r_s);
        LDRGBY_r = model.data.color.rgb2itti(rgb_r_c, rgb_l_s);
        
        % Consolidate to get all horizontal color opponency..
        LDRGBY_h(:,:,:,scale) = max(LDRGBY_l, LDRGBY_r);
    end
end

function [l_ON, r_ON] = left_and_right_ON(color, scale, config)
    l_ON = model.data.utils.on(apply_left_excitatory_filter(color, scale, config));
    r_ON = model.data.utils.on(apply_right_excitatory_filter(color, scale, config));
end

function [l_OFF, r_OFF] = left_and_right_OFF(color, scale, config)
    l_OFF = model.data.utils.off(apply_left_inhibitory_filter(color, scale, config));
    r_OFF = model.data.utils.off(apply_right_inhibitory_filter(color, scale, config));
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