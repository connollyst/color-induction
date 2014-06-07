function I_out = NCZLd_channel_v1_0(I, config)
% from NCZLd_channel_v1_0.m to NCZLd_channel_ON_OFF_v1_1.m
% perform the wavelet decomposition and its inverse transform
%   I: the input image(s) of the format, for example:
%       I{frame}(:,:,:)
%       If an image sequence is to be processed, config.compute.dynamic
%       should be 1, and the number of images passed should match
%       config.wave.n_scales

    %-------------------------------------------------------
    n_membr  = config.zli.n_membr;
    n_scales = config.wave.n_scales;
    %-------------------------------------------------------
    
    config.wave.fin_scale = n_scales - config.zli.fin_scale_offset;
    
    I_out = init_output(config);
    
    % TODO process all channels at once
    n_channels = config.image.n_channels;
    for channel=1:n_channels
        fprintf('Processing channel %i/%i\n', channel, n_channels);
        [curv, w, c]  = utils.wavelet_decomposition(I(:,:,channel,:), config);
        curv_final    = model.process.NCZLd_channel_ON_OFF_v1_1(curv, config);
        I_channel_out = utils.wavelet_decomposition_inverse(I(:,:,channel,:), w, c, curv_final, n_membr, n_scales);
        I_out(:,:,channel,:) = I_channel_out;
    end
    
end

function I_out = init_output(config)
    n_membr    = config.zli.n_membr;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    width      = config.image.width;
    height     = config.image.height;
    n_channels = config.image.n_channels;
    I_out = cell(n_membr, n_scales, n_orients);
    for t=1:n_membr
        for s=1:n_scales
            for o=1:n_orients
                I_out{t,s,o} = zeros(width, height, n_channels);
            end
        end
    end
end