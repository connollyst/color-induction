function [I_out] = NCZLd_channel_v1_0(I, config)
% from NCZLd_channel_v1_0.m to NCZLd_channel_ON_OFF_v1_1.m
% perform the wavelet decomposition and its inverse transform
% I: input image

    %-------------------------------------------------------
    n_membr  = config.zli.n_membr;
    n_scales = config.wave.n_scales;
    dynamic  = config.compute.dynamic;
    %-------------------------------------------------------
    
    config.wave.fin_scale = n_scales - config.zli.fin_scale_offset;
    
    I_width    = size(I, 1);
    I_height   = size(I, 2);
    I_channels = size(I, 3);
    I_out = zeros(I_width, I_height, I_channels, n_membr);
    
    for channel=1:I_channels
        fprintf('Processing channel %i/%i\n', channel, I_channels);
        [curv, w, c]  = utils.wavelet_decomposition(I, n_membr, n_scales, dynamic);
        curv_final    = model.process.NCZLd_channel_ON_OFF_v1_1(curv, config);
        I_channel_out = utils.wavelet_decomposition_inverse(I, w, c, curv_final, n_membr, n_scales);
        I_out(:,:,channel,:) = I_channel_out;
    end
    
end