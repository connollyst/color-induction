function config = single_opponent()
    config.zli     = configurations.defaults.get_zli();
    config.wave    = configurations.defaults.get_wave();
    config.image   = configurations.defaults.get_image();
    config.compute = configurations.defaults.get_compute();
    config.display = configurations.defaults.get_display();
    %config.wave.transform = 'a_trous';
    %config.wave.transform = 'DWD_orient_undecimated';
    config.wave.n_orients = 3;
end