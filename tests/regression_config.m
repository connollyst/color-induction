function config = regression_config(width, height, colors, scales)
%REGRESSION_CONFIG
%   A configuration which sets up the model to behave just like Penacchio
%   & Otazu, 2013. This let's us easily set up the algorithm for regression
%   tests.
    config = configurations.default();
    config.display.logging                 = false;
    config.display.plot                    = false;
    config.zli.n_membr                     = 10;
    config.zli.n_iter                      = 10;
    config.zli.config.zli.add_neural_noise = false;
    config.zli.interaction.color.enabled   = false;
    config.zli.interaction.scale.enabled   = true;
    config.zli.interaction.orient.enabled  = true;
    config.rf.single                       = false;
    config.rf.double                       = true;
    config.image.width                     = width;
    config.image.height                    = height;
    config.image.n_channels                = colors;
    config.wave.transform                  = 'dwt';
    config.wave.n_scales                   = scales;
    config.wave.n_orients                  = 3;
end