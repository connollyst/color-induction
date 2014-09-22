function J_W = JW(scale_interactions, config)
%JW Return J (excitation) & W (inhibition) masks defined by Z. Li 1999.
    if ~config.rf.so.enabled && ~config.rf.do.enabled
        error(['Cannot prepare J & W when both single and double ', ...
               'receptive fields are disabled.']);
    end
    if config.rf.so.enabled && config.rf.do.enabled
        % Both single & double opponent cells:
        % Single opponent cells have no orientation sensitivity.
        % Double opponent cells are sensitive to specific orientations.
        do = 1:3;
        so = 4;
        do_to_so = config.zli.interaction.orient.to_so;
        so_to_do = config.zli.interaction.orient.from_so;
        [J,  W]    = deal(init_struct(scale_interactions, config));
        [Jdo, Wdo] = model.terms.interactions.orients.jw.directional(scale_interactions, config);
        [Jso, Wso] = model.terms.interactions.orients.jw.nondirectional(scale_interactions, config);
        for s=1:config.wave.n_scales
            % DO -> DO excitation (bowtie)
            J{s}(:, :, :, do, do) = Jdo{s};
            W{s}(:, :, :, do, do) = Wdo{s};
        end
        for s=1:config.wave.n_scales
            for o=1:config.wave.n_orients
                if o == so
                    % SO -> SO excitation (gaussian)
                    J{s}(:, :, :, so, so) = Jso{s};
                    W{s}(:, :, :, so, so) = Wso{s};
                    % DO -> SO excitation (gaussian)
                    J{s}(:, :, :, do, so) = repmat(Jso{s} * do_to_so, [1, 1, length(do)]);
                    W{s}(:, :, :, do, so) = repmat(Wso{s} * do_to_so, [1, 1, length(do)]);
                else
                    % SO -> SO excitation (gaussian)
                    J{s}(:, :, :, so, o) = Jso{s} * so_to_do;
                    W{s}(:, :, :, so, o) = Wso{s} * so_to_do;
                end
            end
        end
    else
        if config.rf.do.enabled
            % Only double opponent cells: sensitive to specific orientations
            [J, W] = model.terms.interactions.orients.jw.directional(scale_interactions, config);
        else
            % Only single opponent cells: no orientation sensitivity
            [J, W] = model.terms.interactions.orients.jw.nondirectional(scale_interactions, config);
        end
    end
    J_W = struct;
    J_W.J = J;
    J_W.W = W;
    J_W.J_fft = model.terms.interactions.orients.jw.utils.to_fft(J, scale_interactions, config);
    J_W.W_fft = model.terms.interactions.orients.jw.utils.to_fft(W, scale_interactions, config);
end

function S = init_struct(scale_interactions, config)
% Initialize the J/W data structure.
% Note that it's a struct array as the size of each interaction map differs
% for each scale.
    n_scales  = config.wave.n_scales;
    n_orients = config.wave.n_orients;
    S = cell(n_scales, 1);
    for s=1:n_scales
        scale_diameter = scale_interactions.diameters(s);
        S{s} = zeros(scale_diameter, scale_diameter, 1, n_orients, n_orients);
    end
end