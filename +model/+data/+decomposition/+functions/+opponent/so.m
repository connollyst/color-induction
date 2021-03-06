function LDRGBY = so(rgb, config)
%SO Single Opponent Decomposition
%   Decomposes the RGB image into it's LDRGBY opponent components. Unlike
%   the double opponent decompositions, here there is no spatial opponency
%   between the receptive fields.
%
%   Input
%       rgb:    the original rgb image
%       config: the model configuration
%   Output
%       LDRGBY: the single opponent color components in the format
%               LDRGBY(column, row, color, scale)

    LDRGBY = zeros(size(rgb,1), size(rgb,2), 6, config.wave.n_scales);
    
    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    for scale=1:config.wave.n_scales
        r_c = center(r, scale, config);
        g_c = center(g, scale, config);
        b_c = center(b, scale, config);
        rgb_c = cat(3, r_c, g_c, b_c);
        r_s = surround(r, scale, config);
        g_s = surround(g, scale, config);
        b_s = surround(b, scale, config);
        rgb_s = cat(3, r_s, g_s, b_s);
        LDRGBY(:,:,:,scale) = model.data.rf.transform(rgb_c, rgb_s, config);
    end
end

function c = center(color, scale, config)
    filter = model.data.rf.center(scale, config);
    c      = model.data.convolutions.optimal_padded(color, filter);
end

function s = surround(color, scale, config)
    filter = model.data.rf.surround(scale, config);
    s      = model.data.convolutions.optimal_padded(color, filter);
end