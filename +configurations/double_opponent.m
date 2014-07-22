function config = double_opponent()

    config     = configurations.default();
    config.zli = configurations.opponent.get_zli();
    
    % Decompose with an oriented wavelet transform
    config.wave.transform = 'DWD_orient_undecimated';
    config.wave.n_orients = 3;
end