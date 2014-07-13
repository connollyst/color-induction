function O = process(I, config)
%   I: the input images, either in the form I(cols, rows, colors) or
%      I{frames}(cols, rows, colors)
%   config: the algorithm configuration structure

    start_time = tic;
    
    I      = init_input(I, config);
    config = init_config(I, config);
    
    n_membr = config.zli.n_membr;
    dynamic = config.image.dynamic;

    if model.utils.is_uniform(I)
        % If the image is uniform we do not process it
        O = get_initial_I(I, n_membr, dynamic);
    else
        O = model.process_channel(I, config);
        O = model.utils.average_output(O, config, n_membr, dynamic);
    end

    % Print processing time
    logger.log('Total elapsed time is %0.2f seconds.\n', toc(start_time), config);
end

function I = init_input(I_in, config)
%INIT_INPUT Initialize the input image(s)
%   If it is a single image, return a 1x1 cell containg just that image.
%   If it is a cell array of images, return the cell array.
    if ~iscell(I_in)
        I_in = double(I_in);
        I = cell(1, 1);
        I{1} = I_in;
    else
        % TODO validate input images: same dimensions
        I = I_in;
    end
    
    % Transform the original image data to the color space for processing
    switch config.image.type
        case 'bw'
            % Just process intensity..
            for i=1:length(I)
                I{i} = im2double(I{i});
            end
        case 'rgb'
            % Transform from RGB to L*a*b
            cform = makecform('srgb2lab');
            for i=1:length(I)
                I{i} = lab2double(applycform(I{i}, cform));
            end
        case 'lab'
            % Trust that the input data is already in L*a*b..
        otherwise
            error('Invalid input image type: %s', config.image.type)
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
        config.wave.n_scales = model.utils.calculate_n_scales(I, config);    
    end
    logger.log('Processing at %i scales\n', config.wave.n_scales, config);
    
    % Calculate the scale deltas
    config.wave.scale_deltas = model.utils.calculate_scale_deltas(config);
end

function O = get_initial_I(I, n_membr, dynamic)
    if dynamic ~= 1
        O = zeros([size(I{1}) n_membr]);
    else
        O = zeros(size(I{1}));
    end
    O = O + min(I{1}(:)); % give the initial value to all the pixels
end