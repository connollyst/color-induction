function config = default_rgby()
    config = configurations.default;
    config.image.transform = 'none';
    config.zli.ON_OFF      = 'separate';
    config.wave.transform  = 'opponent';
end