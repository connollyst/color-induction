function g = surround_middle_right(scale, config)
    g = fliplr(model.data.decomposition.functions.opponent.rf.oriented.surround_middle_left(scale, config));
end