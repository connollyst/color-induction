function config = wavelet_opponent()
    config = configurations.default();
    config.rf.single      = false;
    config.rf.double      = true;
    config.wave.n_orients = 3;
    config.wave.transform = 'dwt_rgby';
end