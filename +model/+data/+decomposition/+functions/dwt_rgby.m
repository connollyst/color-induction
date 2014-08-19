function [wavelets, residuals] = dwt_rgby(rgb, config)
% Implementation of Mallate Discrete Wavelet Transform, tailored for RGB
% input and RGBY output.
%
% inputs:
%   rgb:  input rgb to be decomposed
%   scales: # of wavelet scales
%
% outputs:
%   wavelets: cell array of wavelet planes in 3 orientations
%   residuals: cell array of residual planes
    rgb  = im2double(rgb);
    rgby = rgb2rgby(rgb);
    [wavelets, residuals] = model.data.decomposition.functions.dwt(rgby, config);
end

function RGBY = rgb2rgby(rgb)
    n_cols     = size(rgb, 1);
    n_rows     = size(rgb, 2);
    n_channels = 4;             % RGBY
    n_scales   = size(rgb, 4);
    n_orients  = size(rgb, 5);
    RGBY = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);

    r = rgb(:,:,1,:,:);
    g = rgb(:,:,2,:,:);
    b = rgb(:,:,3,:,:);
    
    R = r - (g + b)/2;
    G = g - (r + b)/2;
    B = b - (r + g)/2;
    Y = (r + g)/2 - abs(r - g)/2 - b;

    RGBY(:,:,1,:,:) = R;
    RGBY(:,:,2,:,:) = G;
    RGBY(:,:,3,:,:) = B;
    RGBY(:,:,4,:,:) = Y;
end