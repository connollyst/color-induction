function LDRGBY = irgb2itti(varargin)
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
            irgb_center   = im2double(varargin{1});
            irgb_surround = im2double(varargin{1});
        case 2
            irgb_center   = im2double(varargin{1});
            irgb_surround = im2double(varargin{2});
        otherwise
            error('Expected 1 or 2 parameters, got %i', length(varargin));
    end

    n_cols     = size(irgb_center, 1);
    n_rows     = size(irgb_center, 2);
    n_channels = 6;  % LDRGBY

    LDRGBY = zeros(n_cols, n_rows, n_channels);
    
    i_c = irgb_center(:,:,1);
    r_c = irgb_center(:,:,2);
    g_c = irgb_center(:,:,3);
    b_c = irgb_center(:,:,4);
    
    i_s = irgb_surround(:,:,1); % TODO how to use intensity surround?
    r_s = irgb_surround(:,:,2);
    g_s = irgb_surround(:,:,3);
    b_s = irgb_surround(:,:,4);
    
    L = model.data.utils.on(i_c);
    D = model.data.utils.off(i_c);
    R = model.data.utils.on(r_c - (g_s + b_s)/2);
    G = model.data.utils.on(g_c - (r_s + b_s)/2);
    B = model.data.utils.on(b_c - (r_s + g_s)/2);
    Y = model.data.utils.on((r_c + g_c)/2 - abs(r_s - g_s)/2 - b_s);
    
    LDRGBY(:,:,1) = L;
    LDRGBY(:,:,2) = D;
    LDRGBY(:,:,3) = R;
    LDRGBY(:,:,4) = G;
    LDRGBY(:,:,5) = B;
    LDRGBY(:,:,6) = Y;
end