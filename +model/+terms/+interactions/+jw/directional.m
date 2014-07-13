function JW = directional(interactions, config)
%JW.DIRECTIONAL Return directional J (excitation) & W (inhibition).
%   Reference: Z. Li 1999.

    % TODO perhaps J & W don't need the interactions?
    scale_deltas    = interactions.scale_deltas;
    scale_diameters = interactions.scale_diameters;
    
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    transform  = config.wave.transform;
    
    J = cell(n_scales, 1);
    W = cell(n_scales, 1);
   
    for s=1:n_scales
        scale_diameter = scale_diameters(s);
        % TODO J & W should NOT be sized by the scale!
        J{s} = zeros(scale_diameter, scale_diameter, 1, n_orients, n_orients);
        W{s} = zeros(scale_diameter, scale_diameter, 1, n_orients, n_orients);
        for o=1:n_orients
            [J{s}(:,:,1,:,o), W{s}(:,:,1,:,o)] = ...
                model.terms.interactions.jw.utils.get_Jithetajtheta_v0_4( ...
                    s, n_orients, o, scale_deltas(s), transform, config.zli ...
                );
        end
    end

    [J_fft, W_fft] = model.terms.interactions.jw.utils.to_fft(J, W, interactions, config);
    
    JW = struct;
    JW.J = J;
    JW.W = W;
    JW.J_fft = J_fft;
    JW.W_fft = W_fft;
end