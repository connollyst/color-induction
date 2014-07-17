function J_W = JW(interactions, config)
%GET_JW Return J (excitation) & W (inhibition) masks defined by Z. Li 1999.

    n_orients = config.wave.n_orients;
    switch n_orients
        case 3
            [J, W] = model.terms.interactions.orients.jw.directional(interactions, config);
        case 1
            [J, W] = model.terms.interactions.orients.jw.nondirectional(interactions, config);
        otherwise
            error('Cannot prepare J & W for n_orients = %i', n_orients)
    end
    
    J_W = struct;
    J_W.J = J;
    J_W.W = W;
    J_W.J_fft = model.terms.interactions.orients.jw.utils.to_fft(J, interactions, config);
    J_W.W_fft = model.terms.interactions.orients.jw.utils.to_fft(W, interactions, config);
end