function y_ie = apply_inhibition(gx, interactions, config)
    filter = interactions.orient.JW.W_fft;
    y_ie   = model.terms.interactions.orients.apply_filter(...
                gx, filter, interactions, config ...
           );
end

