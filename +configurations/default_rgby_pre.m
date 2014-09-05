function config = default_rgby_pre()
    config = configurations.default();
    config.zli.ON_OFF           = 'on';
    config.image.transform.pre  = 'rgb2rgby';
    config.image.transform.post = 'none';
end