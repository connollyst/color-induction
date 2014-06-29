function O = NCZLd(I, config)
%   I: the input images, either in the form I(cols, rows, colors) or
%      I{frames}(cols, rows, colors)
%   config: the algorithm configuration structure


    % Track processing time
    start_time = tic;
    
    I = init_input(I);
    
    % Display input image dimensions
    config.image.width      = size(I{1}, 1);
    config.image.height     = size(I{1}, 2);
    config.image.n_channels = size(I{1}, 3);
    logger.log('Image size: %ix%ix%i\n', config.image.width, config.image.height, config.image.n_channels, config);
    
    %-------------------------------------------------------
    zli     = config.zli;
    n_membr = zli.n_membr;
    dynamic = config.compute.dynamic;
    %-------------------------------------------------------
    
    % Calculate number of scales automatically
    if config.wave.n_scales == 0
        config.wave.n_scales = calculate_scales(I, config);    
    end
    logger.log('Processing at %i scales\n', config.wave.n_scales, config);
    
    config.wave.scale_deltas = zli.Delta * utils.scale2size(1:config.wave.n_scales, zli.scale2size_type, zli.scale2size_epsilon);
    
    %-------------------------------------------------------

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% NCZLd for every channel %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if is_uniform(I)
        % If the image is uniform we do not process it
        O = get_initial_I(I, n_membr, dynamic);
    else
        O = model.process.NCZLd_channel_v1_0(I, config);
        O = average_scale_output(O, config, n_membr, dynamic);
    end

    % Print processing time
    logger.log('Total elapsed time is %0.2f seconds.\n', toc(start_time), config);
end

function I_init = init_input(I_in)
%INIT_INPUT initialize the input image(s)
%   If it is a single image, return a 1x1 cell containg just that image.
%   If it is a cell array of images, return the cell array.
    if ~iscell(I_in)
        I_in = double(I_in);
        I_init = cell(1, 1);
        I_init{1} = I_in;
    else
        % TODO validate input images: same dimensions
        I_init = I_in;
    end
end

function n_scales = calculate_scales(I, config)
    if config.zli.fin_scale_offset == 0
        % parameter to adjust the correct number of the last wavelet plane (obsolete)
        % TODO if this is obsolete, can it be removed?
        extra = 1;
    else
        extra = 2;
    end
    mida_min = config.wave.mida_min;
    % TODO scales should be calculated using all colors/frames
    n_scales = floor(log(max(size(I{1}(:,:,1))-1)/mida_min)/log(2)) + extra;
end

function uniform = is_uniform(I)
    % TODO how should this behave for colored images and movies?
    uniform = max(I{1}(:)) == min(I{1}(:));
end

function O = get_initial_I(I, n_membr, dynamic)
    if dynamic ~= 1
        O = zeros([size(I{1}) n_membr]);
    else
        O = zeros(size(I{1}));
    end
    O = O + min(I{1}(:)); % give the initial value to all the pixels
end

function O = average_scale_output(I, config, n_membr, dynamic)
    % Static case
    if dynamic == 0
        % We take the mean as the output, as in Li, 1999
        n_frames_promig = config.image.n_frames_promig;
        t_start         = n_membr - n_frames_promig + 1;
        t_end           = n_membr;
        I_dims = ndims(I{1});
        I_flat = cat(I_dims+1, I{t_start:t_end});
        O = mean(I_flat, I_dims+1);
    end
end