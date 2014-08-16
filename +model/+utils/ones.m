function x = ones( config )
%ONES A utility function for creating a matrix of ones, sized
%     appropriately for our model configuration.
    n_cols       = config.image.width;
    n_rows       = config.image.height;
    n_channels   = config.image.n_channels;
    n_scales     = config.wave.n_scales;
    n_components = config.wave.n_components;
    x = ones(n_cols, n_rows, n_channels, n_scales, n_components);
end

