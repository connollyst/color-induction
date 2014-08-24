function RGBY = so(rgb, config)
%SO Single Opponent Decomposition
%   Decomposes the RGB image into it's RGBY opponent components. Unlike the
%   double opponent decompositions, here there is no spatial opponency
%   between the receptive fields.
%
%   Input
%       rgb:    the original rgb image
%       config: the model configuration
%   Output
%       RGBY_h: the horizontal opponent color components in the format
%               RGBY_h(column, row, color, scale)

    RGBY = zeros(size(rgb,1), size(rgb,2), 4, config.wave.n_scales);
    
    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    for scale=1:config.wave.n_scales
        r_c = center(r, scale, config);
        g_c = center(g, scale, config);
        b_c = center(b, scale, config);

        r_s = surround(r, scale, config);
        g_s = surround(g, scale, config);
        b_s = surround(b, scale, config);

        % Combine center surround signals to obtain color opponency..
        R = model.data.utils.on(r_c - (g_s + b_s)/2);
        G = model.data.utils.on(g_c - (r_s + b_s)/2);
        B = model.data.utils.on(b_c - (r_s + g_s)/2);
        Y = model.data.utils.on((r_c + g_c)/2 - abs(r_s - g_s)/2 - b_s);
        
        RGBY(:,:,1,scale) = R;
        RGBY(:,:,2,scale) = G;
        RGBY(:,:,3,scale) = B;
        RGBY(:,:,4,scale) = Y;
    end
end

function c = center(color, scale, config)
    filter = model.data.decomposition.functions.opponent.rf.center(scale, config);
    c      = model.data.convolutions.optimal_padded(color, filter);
end

function s = surround(color, scale, config)
    filter = model.data.decomposition.functions.opponent.rf.surround(scale, config);
    s      = model.data.convolutions.optimal_padded(color, filter);
end