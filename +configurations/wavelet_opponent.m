function config = wavelet_opponent()
    config = configurations.default();
    config.rf.single      = true;
    config.rf.double      = true;
    config.wave.n_orients = 4;  % DO and SO
    config.wave.transform = 'dwt';
end