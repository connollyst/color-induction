function config = single_opponent_lab()
    config = configurations.default_lab();
    config.rf.single      = true;
    config.rf.double      = false;
    config.wave.n_orients = 1;
end