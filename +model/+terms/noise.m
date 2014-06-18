function N = noise(config)
%GENERATE_NOISE Generate neural noise.
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    if config.zli.add_neural_noise
        N = 0.2 * rand(n_cols, n_rows, n_channels, n_scales, n_orients) - 0.5;
    else
        N = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    end
end