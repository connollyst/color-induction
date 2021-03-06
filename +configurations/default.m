function config = default()
    config.rf      = configurations.components.get_rf();
    config.zli     = configurations.components.get_zli();
    config.wave    = configurations.components.get_wave();
    config.image   = configurations.components.get_image();
    config.compute = configurations.components.get_compute();
    config.display = configurations.components.get_display();
end