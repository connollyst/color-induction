function I_out = NCZLd_channel_v1_0(I, config)
%NCZLD_CHANNEL_V1_0
%   Perform the wavelet decomposition, process the ON & OFF channels, and
%   recover the output with an inverse wavelet transformation.
%
%   I:      The input image(s) of the format, for example:
%           I{frame}(:,:,:)
%           If an image sequence is to be processed, config.compute.dynamic
%           should be 1, and the number of images passed should match
%           config.wave.n_scales
%
%   I_out: The output data is a 3D cell array of 1) membrane time steps,
%          2) spatial frequency scales, and 3) cell orientation preferences.
%          Each cell in the array has the dimensions of the original image,
%          each pixel indicating the excitation at that row & column
%          position and channel.

    n_membr  = config.zli.n_membr;
    n_scales = config.wave.n_scales;
    
    config.wave.fin_scale = n_scales - config.zli.fin_scale_offset;
    
    [curv, w, c] = utils.wavelet_decomposition(I, config);
    curv_final   = model.process.NCZLd_channel_ON_OFF_v1_1(curv, config);
    I_out        = utils.wavelet_decomposition_inverse(I, w, c, curv_final, n_membr, n_scales);
end