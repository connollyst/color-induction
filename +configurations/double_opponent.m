function config = double_opponent()
    config = configurations.default();
    % Decompose with an oriented wavelet transform
    config.wave.transform = 'DWD_orient_undecimated';
    config.wave.n_orients = 3;
    % Treat the ON & OFF values as interacting opponents
    config.zli.ON_OFF = 'opponent';
    config.zli.channel_interaction = 1;
end