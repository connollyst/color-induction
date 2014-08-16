function g = center(scale, config, angle, offset)
    g = model.data.wavelet.functions.opponent.rf.utils.gaussian(                                              ...
            [config.rf.size config.rf.size],                            ...
            (config.rf.center.width  * scale) ^ 2,                      ...
            (config.rf.center.length * scale) ^ 2,                      ...
            angle, 0,                                                   ...
            config.rf.center.weight,                                    ...
            offset                                                      ...
        );
end