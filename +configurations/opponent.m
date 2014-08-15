function config = opponent()
    config      = configurations.default();
    config.rf   = configurations.opponent.get_rf();
    config.zli  = configurations.opponent.get_zli();
    config.wave = configurations.opponent.get_wave();
end