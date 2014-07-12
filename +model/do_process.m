function O = do_process(I, config)
%   I: the input images, either in the form I(cols, rows, colors) or
%      I{frames}(cols, rows, colors)
%   config: the algorithm configuration structure

    start_time = tic;
    
    I      = init_input(I);
    config = init_config(I, config);
    
    n_membr = config.zli.n_membr;
    dynamic = config.compute.dynamic;

    if utils.is_uniform(I)
        % If the image is uniform we do not process it
        O = get_initial_I(I, n_membr, dynamic);
    else
        O = model.NCZLd_channel_v1_0(I, config);
        O = model.utils.average_output(O, config, n_membr, dynamic);
    end

    % Print processing time
    logger.log('Total elapsed time is %0.2f seconds.\n', toc(start_time), config);
end

function I_init = init_input(I_in)
%INIT_INPUT Initialize the input image(s)
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

function config = init_config(I, config)
%INIT_CONFIG Initialize the configuration
%   Some values about the input data are recorded, some values may need to
%   be inferred or calculated.

    % Record input image dimensions
    config.image.width      = size(I{1}, 1);
    config.image.height     = size(I{1}, 2);
    config.image.n_channels = size(I{1}, 3);
    logger.log('Image size: %ix%ix%i\n', config.image.width, config.image.height, config.image.n_channels, config);
    
    % Calculate number of scales automatically
    if config.wave.n_scales == 0
        config.wave.n_scales = utils.calculate_n_scales(I, config);    
    end
    logger.log('Processing at %i scales\n', config.wave.n_scales, config);
    
    % Calculate the scale deltas
    config.wave.scale_deltas = utils.calculate_scale_deltas(config);
end

function O = get_initial_I(I, n_membr, dynamic)
    if dynamic ~= 1
        O = zeros([size(I{1}) n_membr]);
    else
        O = zeros(size(I{1}));
    end
    O = O + min(I{1}(:)); % give the initial value to all the pixels
end