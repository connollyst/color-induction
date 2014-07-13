function I_out = process_channel(I, config)
%PROCESS_CHANNEL
%   Perform the wavelet decomposition, process the ON & OFF channels, and
%   recover the output with an inverse wavelet transformation.
%
%   I:      The input image(s) of the format, for example: I{frame}(:,:,:)
%
%   I_out: The output data is a 3D cell array of 1) cell orientation
%          preferences, 2) spatial frequency scales, and 3) membrane time
%          steps.
%          Each cell in the array has the dimensions of the original image,
%          each pixel indicating the excitation at that row, column &
%          channel.
    [wavelet, residual] = model.wavelet.decomposition(I, config);
    wavelet_out         = model.process_channel_on_off(wavelet, config);
    I_out               = model.wavelet.decomposition_inverse(wavelet_out, residual, config);
end