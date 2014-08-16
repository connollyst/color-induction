function config = double_opponent()
    config = configurations.default();
    config.rf.double         = true;
    config.rf.single         = false;
    config.wave.n_orients    = 3;
    config.wave.n_components = 3;
end