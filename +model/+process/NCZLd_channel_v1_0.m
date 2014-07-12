function I_out = NCZLd_channel_v1_0(I, config)
%NCZLD_CHANNEL_V1_0
%   Perform the wavelet decomposition, process the ON & OFF channels, and
%   recover the output with an inverse wavelet transformation.
%
%   I:      The input image(s) of the format, for example:
%           I{frame}(:,:,:)
%           If an image sequence is to be processed, config.compute.dynamic
%           should be 1, and the number of images passed should match
%           config.wave.n_scales. If only one image is to be processed, the
%           length of I should be 1.
%
%   I_out: The output data is a 3D cell array of 1) cell orientation
%          preferences, 2) spatial frequency scales, and 3) membrane time
%          steps.
%          Each cell in the array has the dimensions of the original image,
%          each pixel indicating the excitation at that row, column &
%          channel.
    [wavelet, residual] = model.wavelet_decomposition(I, config);
    wavelet_out         = model.process.NCZLd_channel_ON_OFF_v1_1(wavelet, config);
    I_out               = model.wavelet_decomposition_inverse(wavelet_out, residual, config);
end