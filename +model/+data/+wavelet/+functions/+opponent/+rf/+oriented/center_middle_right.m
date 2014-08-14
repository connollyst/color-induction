function g = center_middle_right(scale, config)
    g = fliplr(model.data.wavelet.functions.opponent.rf.oriented.center_middle_left(scale, config));
end