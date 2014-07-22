function config = get_test_config(width, height, colors, scales)
    config = configurations.default();
    config.display.logging                 = false;
    config.display.plot                    = false;
    config.zli.config.zli.add_neural_noise = false;
    config.image.width                     = width;
    config.image.height                    = height;
    config.image.n_channels                = colors;
    config.wave.n_scales                   = scales;
end