function RGBY = rgby(rgb)
%RGBY Red Green Blue Yellow color transform, based on L. Itti 1998
%
%   Input
%       rgb:    the original rgb image
%       config: the model configuration
%   Output
%       RGBY_h: the vertical opponent color components in the format
%               RGBY_h(column, row, color, scale)

    RGBY = zeros(size(rgb,1), size(rgb,2), 4);
    
    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    R = r - (g + b)/2;
    G = g - (r + b)/2;
    B = b - (r + g)/2;
    Y = (r + g)/2 - abs(r - g)/2 - b;

    RGBY(:,:,1) = R;
    RGBY(:,:,2) = G;
    RGBY(:,:,3) = B;
    RGBY(:,:,4) = Y;
end

function [t_center, b_center] = top_bottom_center(color, scale, config)
    t_center = model.data.utils.on(apply_top_center_filter(color, scale, config));
    b_center = model.data.utils.on(apply_bottom_center_filter(color, scale, config));
end

function [t_surround, b_surround] = top_bottom_surround(color, scale, config)
    t_surround = model.data.utils.off(apply_top_surround_filter(color, scale, config));
    b_surround = model.data.utils.off(apply_bottom_surround_filter(color, scale, config));
end

function I_out = apply_top_center_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.center_top_middle(scale, config)      ...
             - model.data.wavelet.functions.opponent.rf.oriented.center_bottom_middle(scale, config);
    I_out = model.data.convolutions.optimal_padded(color, filter());
end

function I_out = apply_bottom_center_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.center_bottom_middle(scale, config)   ...
             - model.data.wavelet.functions.opponent.rf.oriented.center_top_middle(scale, config);
    I_out = model.data.convolutions.optimal_padded(color, filter());
end

function I_out = apply_top_surround_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.surround_top_middle(scale, config)    ...
             - model.data.wavelet.functions.opponent.rf.oriented.surround_bottom_middle(scale, config);
    I_out = model.data.convolutions.optimal_padded(color, filter());
end

function I_out = apply_bottom_surround_filter(color, scale, config)
    filter =   model.data.wavelet.functions.opponent.rf.oriented.surround_bottom_middle(scale, config) ...
             - model.data.wavelet.functions.opponent.rf.oriented.surround_top_middle(scale, config);
    I_out = model.data.convolutions.optimal_padded(color, filter());
end