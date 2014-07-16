function config = double_opponent()
    config = configurations.default();
    config.wave.transform = 'DWD_orient_undecimated';
    config.wave.n_orients = 3;
    config.zli.channel_interactions = 1;
end