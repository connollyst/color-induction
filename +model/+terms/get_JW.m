function JW = get_JW(interactions, config)
%GET_JW Return J (excitation) & W (inhibition) masks defined by Z. Li 1999.

    n_orients = config.wave.n_orients;
    switch n_orients
        case 3
            [J, W] = model.terms.interactions.jw.directional(interactions, config);
        case 1
            [J, W] = model.terms.interactions.jw.nondirectional(interactions, config);
        otherwise
            error('Cannot prepare J & W for n_orients = %i', n_orients)
    end
    
    JW = struct;
    JW.J = J;
    JW.W = W;
    JW.J_fft = model.terms.interactions.jw.utils.to_fft(J, interactions, config);
    JW.W_fft = model.terms.interactions.jw.utils.to_fft(W, interactions, config);
end