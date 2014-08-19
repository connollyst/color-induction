function g = center_bottom_right(scale, config)
    g = fliplr(model.data.decomposition.functions.opponent.rf.oriented.center_bottom_left(scale, config));
end