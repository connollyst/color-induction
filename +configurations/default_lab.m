function config = default_lab()
    config = configurations.default;
    config.image.transform = 'rgb2lab';
    config.zli.ON_OFF      = 'separate';
    config.wave.transform  = 'dwt';
end