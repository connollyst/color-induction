function config = default()
    config.rf      = configurations.opponent.get_rf();
    config.zli     = configurations.opponent.get_zli();
    config.wave    = configurations.opponent.get_wave();
    config.image   = configurations.defaults.get_image();
    config.compute = configurations.defaults.get_compute();
    config.display = configurations.defaults.get_display();
    % TODO we need to support 4 orients by default
    config.wave.n_orients = 3;
end