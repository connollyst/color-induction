function x_ee = apply_excitation(gx_padded, orient_interactions, scale_interactions, config)
    filter = orient_interactions.JW.J_fft;
    x_ee   = model.terms.interactions.orients.apply_filter(...
                gx_padded, filter, scale_interactions, config ...
           );
end

