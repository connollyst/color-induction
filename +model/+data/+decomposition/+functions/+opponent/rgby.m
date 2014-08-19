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