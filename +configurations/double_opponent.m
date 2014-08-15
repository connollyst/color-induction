function config = double_opponent()
    config = configurations.opponent();
    config.rf.single_enabled = false;
    config.rf.double_enabled = true;
    config.wave.n_orients    = 3;
end