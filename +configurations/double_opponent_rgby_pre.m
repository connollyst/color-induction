function config = double_opponent_rgby_pre()
    config = configurations.default_rgby_pre();
    config.rf.single      = false;
    config.rf.double      = true;
    config.wave.n_orients = 3;
end