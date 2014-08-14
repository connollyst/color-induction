function g = surround_bottom_right(scale, config)
    g = fliplr(model.data.wavelet.functions.opponent.rf.oriented.surround_bottom_left(scale, config));
end