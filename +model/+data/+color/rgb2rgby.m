function RGBY = rgb2rgby(rgb)
%RGB2RGBY Red Green Blue Yellow color transform, based on L. Itti 1998
%
%   Input
%       rgb:  the original rgb image
%   Output
%       RGBY: the opponent color components
    
    n_cols     = size(rgb, 1);
    n_rows     = size(rgb, 2);
    n_channels = 4;             % RGBY

    RGBY = zeros(n_cols, n_rows, n_channels);
    
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