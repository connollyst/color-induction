function y_ie = apply_inhibition(gx_padded, orient_interactions, scale_interactions, config)
    filter = orient_interactions.JW.W_fft;
    y_ie   = model.terms.interactions.orients.apply_filter(...
                gx_padded, filter, scale_interactions, config ...
           );
end

