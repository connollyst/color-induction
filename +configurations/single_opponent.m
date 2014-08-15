function config = single_opponent()
    config = configurations.opponent();
    config.rf.single_enabled = true;
    config.rf.double_enabled = false;
    config.wave.n_orients    = 1;
end