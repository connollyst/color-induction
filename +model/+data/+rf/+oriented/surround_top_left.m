function g = surround_top_left(scale, config)
    g = model.data.rf.oriented.surround(                                   ...
            scale,                                                         ...
            config,                                                        ...
            -45,                                                           ...
            [-config.rf.do.surround.offset -config.rf.do.surround.offset]  ...
        );
end