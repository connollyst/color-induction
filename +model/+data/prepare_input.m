function [ON_OFF_in, residuals, config] = prepare_input(I, config)
%PREPARE_INPUT Takes initial input data and prepares it for processing.
%   The input data is expected to be either a single image, or a sequence
%   of images in a 1D cell array.
%
%   w: the planes of the wavelet decomposition
%   r: the residuals of the wavelet decomposition

    I_cells               = model.data.utils.to_cells(I);
    I_opponent            = model.data.color.pretransform(I_cells, config);
    [wavelets, residuals] = model.data.decomposition.apply(I_opponent, config);
    [wavelets, residuals] = model.data.color.posttransform(wavelets, residuals, config);
    config                = record_dimensions(wavelets, config);
    ON_OFF_in             = model.data.on_off.prepare(wavelets, config);
    if strcmp(config.zli.ON_OFF, 'separate')
        % EEK! this isn't right..?!
        config.image.n_channels = config.image.n_channels * 2;
    end
end

function config = record_dimensions(I, config)
%RECORD_DIMENSIONS Record the image dimensions in the config.
    config.image.width      = size(I{1}, 1);
    config.image.height     = size(I{1}, 2);
    config.image.n_channels = size(I{1}, 3);
    logger.log('Image size: %ix%ix%i\n', config.image.width, config.image.height, config.image.n_channels, config);
end