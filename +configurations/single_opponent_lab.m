function config = single_opponent_lab()
    config = configurations.default_lab;
    config.rf.so.enabled  = true;
    config.rf.do.enabled  = false;
    config.wave.n_orients = 1;
end