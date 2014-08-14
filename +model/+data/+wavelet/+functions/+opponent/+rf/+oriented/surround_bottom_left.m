function g = surround_bottom_left(scale, config)
    g = flipud(model.data.wavelet.functions.opponent.rf.oriented.surround_top_left(scale, config));
end

