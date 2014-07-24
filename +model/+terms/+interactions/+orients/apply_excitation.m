function x_ee = apply_excitation(gx, interactions, config)
    filter = interactions.orient.JW.J_fft;
    x_ee   = model.terms.interactions.orients.apply_filter(...
                gx, filter, interactions, config ...
           );
end

