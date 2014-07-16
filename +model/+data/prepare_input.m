function [wavelets, residuals, config] = prepare_input(I_in, config)
%PREPARE_INPUT Takes initial input data and prepares it for processing.
%   The input data is expected to be either a single image, or a sequence
%   of images in a 1D cell array.
    I                     = model.data.color.transform(I_in, config);
    config                = record_dimensions(I, config);
    [wavelets, residuals] = model.data.wavelet.decomposition(I, config);
end

function config = record_dimensions(I, config)
%RECORD_DIMENSIONS Record the image dimensions in the config.
    config.image.width      = size(I{1}, 1);
    config.image.height     = size(I{1}, 2);
    config.image.n_channels = size(I{1}, 3);
    logger.log('Image size: %ix%ix%i\n', config.image.width, config.image.height, config.image.n_channels, config);
end