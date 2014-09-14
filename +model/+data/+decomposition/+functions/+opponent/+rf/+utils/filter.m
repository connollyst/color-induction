function LDRGBY_filtered = filter(rgb, rf_on, rf_off)
    i        = mean(rgb, 3);
    i_on     = model.data.convolutions.optimal_padded(i,   rf_on);
    rgb_on   = model.data.convolutions.optimal_padded(rgb, rf_on);
    i_off    = model.data.convolutions.optimal_padded(i,   rf_off);
    rgb_off  = model.data.convolutions.optimal_padded(rgb, rf_off);
    irgb_on  = cat(3, i_on,  rgb_on);
    irgb_off = cat(3, i_off, rgb_off);
    LDRGBY_filtered = model.data.color.irgb2itti(irgb_on, irgb_off);
end