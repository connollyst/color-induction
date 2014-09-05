function RGBY = rgb2rgby(varargin)
%RGB2RGBY Red Green Blue Yellow color transform, based on L. Itti 1998
%   Modified from L. Itti to 
%
%   Input
%       rgb_center:   the rgb image of center signal
%       rgb_surround: the rgb image of surround signal
%                     (optional - defaults to rgb_center)
%   Output
%       RGBY: the opponent color components
    
    switch length(varargin)
        case 1
            rgb_center   = im2double(varargin{1});
            rgb_surround = im2double(varargin{1});
        case 2
            rgb_center   = im2double(varargin{1});
            rgb_surround = im2double(varargin{2});
        otherwise
            error('Expected 1 or 2 parameters, got %i', length(varargin));
    end

    n_cols     = size(rgb_center, 1);
    n_rows     = size(rgb_center, 2);
    n_channels = 4;             % RGBY

    RGBY = zeros(n_cols, n_rows, n_channels);
    
    r_c = rgb_center(:,:,1);
    g_c = rgb_center(:,:,2);
    b_c = rgb_center(:,:,3);
    
    r_s = rgb_surround(:,:,1);
    g_s = rgb_surround(:,:,2);
    b_s = rgb_surround(:,:,3);
    
    R = r_c - (g_s + b_s)/2;
    G = g_c - (r_s + b_s)/2;
    B = b_c - (r_s + g_s)/2;
    Y = (r_c + g_c)/2 - abs(r_s - g_s)/2 - b_s;

    RGBY(:,:,1) = R;
    RGBY(:,:,2) = G;
    RGBY(:,:,3) = B;
    RGBY(:,:,4) = Y;
end