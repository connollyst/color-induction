function [wavelets, residuals, config] = prepare_input(I, config)
%PREPARE_INPUT Takes initial input data and prepares it for processing.
%   The input data is expected to be either a single image, or a sequence
%   of images in a 1D cell array.
%
%   wavelets:  the planes of the wavelet decomposition
%   residuals: the residuals of the wavelet decomposition
%   config:    the model configuration: it may be modified during this step
%              as the input is being prepared
    I_cells               = model.data.utils.to_cells(I);
    I_opponent            = model.data.color.pretransform(I_cells, config);
    [wavelets, residuals] = model.data.decomposition.apply(I_opponent, config);
    [wavelets, residuals] = model.data.color.posttransform(wavelets, residuals, config);
    wavelets              = model.data.on_off.prepare(wavelets, config);
    % Update the configuration to reflect the prepared input:
    config                = record_dimensions(wavelets, config);
end

function config = record_dimensions(I, config)
%RECORD_DIMENSIONS Record the image dimensions in the config.
    i = I{1};
    config.image.width      = size(i, 1);
    config.image.height     = size(i, 2);
    config.image.n_channels = size(i, 3);
    config.wave.n_scales    = size(i, 4);
    config.wave.n_orients   = size(i, 5);
    logger.log('Image size: %ix%ix%i\n', config.image.width, config.image.height, config.image.n_channels, config);
    logger.log('Decomposition scales: %i\n', config.wave.n_scales, config);
    logger.log('Decomposition orientations: %i\n', config.wave.n_orients, config);
end