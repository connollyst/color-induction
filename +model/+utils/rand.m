function x = rand( config )
%RAND A utility function for creating a matrix of random numbers, sized
%      appropriately for our model configuration.
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    x = rand(n_cols, n_rows, n_channels, n_scales, n_orients);
end

