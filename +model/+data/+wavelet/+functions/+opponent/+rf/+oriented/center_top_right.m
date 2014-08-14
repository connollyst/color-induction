function g = center_top_right(scale, config)
    g = fliplr(model.data.wavelet.functions.opponent.rf.oriented.center_top_left(scale, config));
end