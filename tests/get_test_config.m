function config = get_test_config(width, height, colors, scales)
    config = configurations.default();
    % Don't add noise in tests
    config.zli.config.zli.add_neural_noise = 0;
    config.wave.n_scales = scales;
    % Prepare image configurations
    config.image.width      = width;
    config.image.height     = height;
    config.image.n_channels = colors;
    % Disable all data display
    config.display.logging = 0;
    config.display.plot    = 0;
end