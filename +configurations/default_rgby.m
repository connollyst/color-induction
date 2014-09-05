function config = default_rgby()
    config = configurations.default();
    config.zli.ON_OFF      = 'on';
    config.color.pretransform = 'rgb2rgby';
end