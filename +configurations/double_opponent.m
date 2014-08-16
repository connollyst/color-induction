function config = double_opponent()
    config = configurations.default();
    config.rf.single      = false;
    config.rf.double      = true;
    config.wave.n_orients = 3;
end