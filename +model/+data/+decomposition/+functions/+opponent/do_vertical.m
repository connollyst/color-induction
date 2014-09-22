function LDRGBY_v = do_vertical(rgb, config)
%DO_VERTICAL Double Opponent (Vertical) Decomposition
%   Decomposes the RGB image into it's RGBY vertical opponent components.
%
%   Input
%       rgb:      the original rgb image
%       config:   the model configuration
%   Output
%       LDRGBY_V: the vertical opponent color components in the format
%                 LDRGBY_v(column, row, color, scale)
    rgb = im2double(rgb);
    LDRGBY_v = zeros(size(rgb,1), size(rgb,2), 6, config.wave.n_scales);
    for scale=1:config.wave.n_scales
        LDRGBY_t2b = model.data.decomposition.functions.opponent.filter(...
                        rgb,                                            ...
                        top2bottom_filter_ON(scale, config),            ...
                        top2bottom_filter_OFF(scale, config)            ...
                     );
        LDRGBY_b2t = model.data.decomposition.functions.opponent.filter(...
                        rgb,                                            ...
                        bottom2top_filter_ON(scale, config),            ...
                        bottom2top_filter_OFF(scale, config)            ...
                     );
        LDRGBY_v(:,:,:,scale) = max(LDRGBY_t2b, LDRGBY_b2t);
    end
end

%% FILTERS

function f = top2bottom_filter_ON(scale, config)
    f =   model.data.rf.oriented.center_top_middle(scale, config)       ...
        - model.data.rf.oriented.center_bottom_middle(scale, config);
end

function f = bottom2top_filter_ON(scale, config)
    f =   model.data.rf.oriented.center_bottom_middle(scale, config)    ...
        - model.data.rf.oriented.center_top_middle(scale, config);
end

function f = top2bottom_filter_OFF(scale, config)
    f =   model.data.rf.oriented.surround_top_middle(scale, config)     ...
        - model.data.rf.oriented.surround_bottom_middle(scale, config);
end

function f = bottom2top_filter_OFF(scale, config)
    f =   model.data.rf.oriented.surround_bottom_middle(scale, config)	...
        - model.data.rf.oriented.surround_top_middle(scale, config);
end