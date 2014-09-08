function g = center(scale, config)
    g = model.data.decomposition.functions.opponent.rf.utils.gaussian(  ...
            [config.rf.size config.rf.size],                            ...
            (config.rf.center.width * scale) ^ 2,                       ...
            (config.rf.center.width * scale) ^ 2,                       ...
            0, 0,                                                       ...
            0.5,                                    ...
            [0 0]                                                       ...
        ) * config.rf.center.weight;
end

