function g = center_bottom_left(scale, config)
    g = flipud(model.data.wavelet.functions.opponent.rf.oriented.center_top_left(scale, config));
end