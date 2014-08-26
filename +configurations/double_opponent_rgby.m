function config = double_opponent_rgby()
    config = configurations.default_rgby();
    config.rf.single      = false;
    config.rf.double      = true;
    config.wave.n_orients = 3;
end