function J_W = JW(scale_interactions, config)
%JW Return J (excitation) & W (inhibition) masks defined by Z. Li 1999.
    if ~config.rf.single && ~config.rf.double
        error(['Cannot prepare J & W when both single and double ', ...
               'receptive fields are disabled.']);
    end
    n_scales     = config.wave.n_scales;
    n_orients    = config.wave.n_orients;
    n_components = config.wave.n_components;
    [J, W] = deal(init_struct(scale_interactions, config));
    if config.rf.double
        % Double opponent cells are sensitive to specific orientations
        [Jd, Wd] = model.terms.interactions.orients.jw.directional(scale_interactions, config);
        for s=1:n_scales
            J{s}(:, :, :, 1:n_orients, 1:n_orients) = Jd{s};
            W{s}(:, :, :, 1:n_orients, 1:n_orients) = Wd{s};
        end
        if config.rf.single
            % Double opponent cells also interact with single opponent cells
            [Js, Ws] = model.terms.interactions.orients.jw.nondirectional(scale_interactions, config);
            for s=1:n_scales
                for o=1:n_orients
                    J{s}(:, :, :, o, n_components) = Js{s};
                    W{s}(:, :, :, o, n_components) = Ws{s};
                end
            end
        end
    end
    if config.rf.single
        % Non-orientation sensitive cells: single opponent cells
        [Js, Ws] = model.terms.interactions.orients.jw.nondirectional(scale_interactions, config);
        for s=1:n_scales
            J{s}(:, :, :, n_components, n_components) = Js{s};
            W{s}(:, :, :, n_components, n_components) = Ws{s};
        end
    end
    J_W = struct;
    J_W.J = J;
    J_W.W = W;
    J_W.J_fft = model.terms.interactions.orients.jw.utils.to_fft(J, scale_interactions, config);
    J_W.W_fft = model.terms.interactions.orients.jw.utils.to_fft(W, scale_interactions, config);
end

function S = init_struct(scale_interactions, config)
    n_scales     = config.wave.n_scales;
    n_components = config.wave.n_components;
    S = cell(n_scales, 1);
    for s=1:n_scales
        scale_diameter = scale_interactions.diameters(s);
        S{s} = zeros(scale_diameter, scale_diameter, 1, n_components, n_components);
    end
end