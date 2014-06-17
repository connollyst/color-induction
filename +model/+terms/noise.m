function N = noise(config)
%GENERATE_NOISE Generate neural noise.
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    var_noise  = 0.1 * 2;
    N          = var_noise * (rand(n_cols, n_rows, n_channels, n_scales, n_orients)) - 0.5;
end