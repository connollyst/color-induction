function LDRGBY_h = do_horizontal(rgb, config)
%DO_HORIZONTAL Double Opponent (Horizontal) Decomposition
%   Decomposes the RGB image into it's RGBY horizontal opponent components.
%
%   Input
%       rgb:      the original rgb image
%       config:   the model configuration
%   Output
%       LDRGBY_h: the horizontal opponent color components in the format
%                 LDRGBY_h(column, row, color, scale)
    rgb = im2double(rgb);
    LDRGBY_h = zeros(size(rgb,1), size(rgb,2), 6, config.wave.n_scales);
    for scale=1:config.wave.n_scales
        LDRGBY_l2r = model.data.decomposition.functions.opponent.filter(...
                        rgb,                                            ...
                        left2right_filter_ON(scale, config), ...
                        left2right_filter_OFF(scale, config) ...
                     );
        LDRGBY_r2l = model.data.decomposition.functions.opponent.filter(...
                        rgb,                                            ...
                        right2left_filter_ON(scale, config), ...
                        right2left_filter_OFF(scale, config) ...
                     );
        LDRGBY_h(:,:,:,scale) = max(LDRGBY_l2r, LDRGBY_r2l);
    end
end

%% FILTERS

function f = left2right_filter_ON(scale, config)
    f =   model.data.rf.oriented.center_middle_left(scale, config) ...
        - model.data.rf.oriented.center_middle_right(scale, config);
end

function f = right2left_filter_ON(scale, config)
    f =   model.data.rf.oriented.center_middle_right(scale, config) ...
        - model.data.rf.oriented.center_middle_left(scale, config);
end

function f = left2right_filter_OFF(scale, config)
    f =   model.data.rf.oriented.surround_middle_left(scale, config) ...
        - model.data.rf.oriented.surround_middle_right(scale, config);
end

function f = right2left_filter_OFF(scale, config)
    f =   model.data.rf.oriented.surround_middle_right(scale, config) ...
        - model.data.rf.oriented.surround_middle_left(scale, config);
end