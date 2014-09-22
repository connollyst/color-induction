function config = double_opponent_lab()
    config = configurations.default_lab;
    config.rf.so.enabled  = false;
    config.rf.do.enabled  = true;
    config.wave.n_orients = 3;
end