function config = single_opponent_rgby()
    config = configurations.default_rgby;
    config.rf.so.enabled  = true;
    config.rf.do.enabled  = false;
    config.wave.n_orients = 1;
end