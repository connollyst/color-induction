function I_out = apply(I_in, config)
%MODEL.APPLY
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

    start_time                    = tic;
    [wavelets, residuals, config] = model.data.prepare_input(I_in, config);
    wavelet_out                   = model.process_data_on_off(wavelets, config);
    I_out                         = model.data.prepare_output(wavelet_out, residuals, config);
    logger.log('Total elapsed time is %0.2f seconds.\n', toc(start_time), config);
end