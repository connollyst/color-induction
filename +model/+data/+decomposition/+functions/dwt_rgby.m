function [wavelets, residuals] = dwt_rgby(rgb, config)
% Implementation of Mallate Discrete Wavelet Transform, tailored for RGB
% input and RGBY output.
%
% Input
%   rgb:        input rgb to be decomposed
%   config:     the model configuration struct array
%
% Output
%   signals:    wavelet planes (input to the model)
%   residuals:  residual planes (for output reconstruction)
    rgb  = im2double(rgb);
    rgby = model.data.color.rgb2rgby(rgb);
    [wavelets, residuals] = model.data.decomposition.functions.dwt(rgby, config);
end