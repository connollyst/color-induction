function config = default_rgby_post()
    config = configurations.default();
    config.zli.ON_OFF           = 'abs';
    config.image.transform.pre  = 'none';
    config.image.transform.post = 'rgb2rgby';
end