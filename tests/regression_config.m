function config = regression_config(width, height, colors, scales)
    config = configurations.default();
    config.display.logging                 = false;
    config.display.plot                    = false;
    config.zli.config.zli.add_neural_noise = false;
    config.zli.interaction.color.enabled   = false;
    config.zli.interaction.scale.enabled   = true;
    config.zli.interaction.orient.enabled  = true;
    config.image.width                     = width;
    config.image.height                    = height;
    config.image.n_channels                = colors;
    config.wave.transform                  = 'dwt';
    config.wave.n_scales                   = scales;
    config.wave.n_orients                  = 3;
end