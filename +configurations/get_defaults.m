function config = get_defaults()
    config.zli     = configurations.defaults.get_zli();
    config.wave    = configurations.defaults.get_wave();
    config.compute = configurations.defaults.get_compute();
    config.display = configurations.defaults.get_display();
    config.image   = configurations.defaults.get_image(config.zli);
end