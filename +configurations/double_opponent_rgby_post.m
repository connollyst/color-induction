function config = double_opponent_rgby_post()
    config = configurations.default_rgby_post();
    config.rf.single      = false;
    config.rf.double      = true;
    config.wave.n_orients = 3;
end