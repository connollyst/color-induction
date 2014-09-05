function config = default_lab()
    config = configurations.default();
    config.zli.ON_OFF           = 'separate';
    config.image.transform.pre  = 'rgb2lab';
    config.image.transform.post = 'none';
end