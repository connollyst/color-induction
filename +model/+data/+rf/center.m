function g = center(scale, config)
    g = model.data.rf.utils.gaussian(                                   ...
            [config.rf.so.size config.rf.so.size],                      ...
            (config.rf.so.center.width * scale) ^ 2,                    ...
            (config.rf.so.center.width * scale) ^ 2,                    ...
            0, 0,                                                       ...
            0.5,                                                        ...
            [0 0]                                                       ...
        ) * config.rf.so.center.weight;
end

