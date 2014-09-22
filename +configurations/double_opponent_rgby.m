function config = double_opponent_rgby()
    config = configurations.default_rgby;
    config.rf.so.enabled  = false;
    config.rf.do.enabled  = true;
    config.wave.n_orients = 3;
end