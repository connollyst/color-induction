function config = single_opponent()
    config = configurations.default();
    config.rf.single         = true;
    config.rf.double         = false;
    config.wave.n_orients    = 0;
    config.wave.n_components = 1;
end