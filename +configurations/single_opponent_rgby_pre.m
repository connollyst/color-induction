function config = single_opponent_rgby_pre()
    config = configurations.default_rgby_pre();
    config.rf.single      = true;
    config.rf.double      = false;
    config.wave.n_orients = 1;
end