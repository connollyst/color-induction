function config = single_opponent()
    config = configurations.default();
    config.rf.single      = true;
    config.rf.double      = false;
    config.wave.n_orients = 1;
end