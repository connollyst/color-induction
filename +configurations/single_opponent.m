function config = single_opponent()
    config = configurations.default();
    config.wave.transform = 'a_trous';
    config.wave.n_orients = 1;
    config.zli.ON_OFF     = 'abs';  % 'abs' or 'square'
end