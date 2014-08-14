function g = center_bottom_right(scale, config)
    g = fliplr(model.data.wavelet.functions.opponent.rf.oriented.center_bottom_left(scale, config));
end