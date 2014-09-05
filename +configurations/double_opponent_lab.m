function config = double_opponent_lab()
    config = configurations.default_lab();
    config.rf.single      = false;
    config.rf.double      = true;
    config.wave.n_orients = 3;
end