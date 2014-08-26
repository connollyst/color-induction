function [I_out, out] = apply(I_in, config)
%MODEL.APPLY
%   Perform the wavelet decomposition, process the ON & OFF channels, and
%   recover the output with an inverse wavelet transformation.
%
%   Input
%       I:      The input image(s) of the format, for example:
%               I{frame}(:,:,:)
%
%   Output
%       I_out:  The output 'perceptual image'
%       out:    The output neuronal activity

    start_time              = tic;    
    [in, residuals, config] = model.data.prepare_input(I_in, config);
    activity                = model.process_induction(in, config);
    [out, I_out]            = model.data.prepare_output(in, activity, residuals, config);
    logger.log('Total elapsed time is %0.2f seconds.\n', toc(start_time), config);
end