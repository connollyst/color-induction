function g = surround_top_right(scale, config)
    g = fliplr(model.data.wavelet.functions.opponent.rf.oriented.surround_top_left(scale, config));
end