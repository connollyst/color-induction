function config = single_opponent()
    config = configurations.default();
    config.wave.transform = 'so';
    config.wave.n_orients = 1;
    config.zli.ON_OFF     = 'abs';
    config.rf             = configurations.opponent.get_rf();
end