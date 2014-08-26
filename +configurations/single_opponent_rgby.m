function config = single_opponent_rgby()
    config = configurations.default_rgby();
    config.rf.single      = true;
    config.rf.double      = false;
    config.wave.n_orients = 1;
end