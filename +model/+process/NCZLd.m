function [I_out] = NCZLd(I, config)
    I = double(I);
    
    % Track processing time
    start_time = tic;
    
    % Display input image dimensions
    I_width      = size(I, 1);
    I_height     = size(I, 2);
    I_dimensions = size(I, 3);
    fprintf('Image size: %ix%ix%i\n', I_width, I_height, I_dimensions);
    
    %-------------------------------------------------------
    zli     = config.zli;
    n_membr = zli.n_membr;
    dynamic = config.compute.dynamic;
    %-------------------------------------------------------
    
    % Calculate number of scales automatically
    if config.wave.n_scales == 0
        config.wave.n_scales = calculate_scales(I, config);    
    end
    fprintf('Processing at %i scales\n', config.wave.n_scales);
    
    %-------------------------------------------------------

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% NCZLd for every channel %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    I_out = model.process.NCZLd_channel_v1_0(I, config);
    
    % Static case
    if dynamic == 0
        % We take the mean as the output, as in Li, 1999
        n_frames_promig = config.image.n_frames_promig;
        ff_ini          = n_membr-n_frames_promig+1;
        ff_fin          = n_membr;
        I_out           = mean(I_out(:,:,ff_ini:ff_fin), 3);
    end

    % Print processing time
    toc(start_time)
end

function n_scales = calculate_scales(I, config)
    if config.zli.fin_scale_offset == 0
        % parameter to adjust the correct number of the last wavelet plane (obsolete)
        % TODO if this is obsolete, can it be removed?
        extra = 2;
    else
        extra = 3;
    end
    mida_min = config.wave.mida_min;
    % TODO scales should be calculated using all dimensions
    n_scales = floor(log(max(size(I(:,:,1))-1)/mida_min)/log(2)) + extra;
end
