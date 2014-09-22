function LDRGBY = rgb2opp(varargin)
%RGB2RGBY Light, Dark, Red, Green, Blue, Yellow color transform.
%   Separate RGB image into intensity (I), red (R), green (G), blue (B),
%   and yellow (Y) components according to the transformations defined in
%   Itti L, Kock C, Niebur E (1998) A model of saliency-based visual
%   attention for rapid scene analysis. IEEE Transactions on Pattern
%   Analysis and Machiene Intelligence 20:1254-1259
%
%   Input
%       rgb_center:   the rgb image of center signal
%       rgb_surround: the rgb image of surround signal
%                     (optional - defaults to rgb_center)
%   Output
%       LDRGBY: the opponent color components
    
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
    n_channels = 6;  % LDRGBY

    LDRGBY = zeros(n_cols, n_rows, n_channels);
    
    r_c = rgb_center(:,:,1);
    g_c = rgb_center(:,:,2);
    b_c = rgb_center(:,:,3);
    i_c = (r_c + g_c)/2 - 0.5;
    
    r_s = rgb_surround(:,:,1);
    g_s = rgb_surround(:,:,2);
    b_s = rgb_surround(:,:,3);
    i_s = (r_s + g_s)/2 - 0.5;
    
    L = model.data.utils.on(i_c - i_s);
    D = model.data.utils.on(i_s - i_c);
    R = model.data.utils.on(r_c - g_s);
    G = model.data.utils.on(g_c - r_s);
    B = model.data.utils.on(b_c - (r_s + g_s)/2);
    Y = model.data.utils.on((r_c + g_c)/2 - b_s);
    
    LDRGBY(:,:,1) = L;
    LDRGBY(:,:,2) = D;
    LDRGBY(:,:,3) = R;
    LDRGBY(:,:,4) = G;
    LDRGBY(:,:,5) = B;
    LDRGBY(:,:,6) = Y;
end