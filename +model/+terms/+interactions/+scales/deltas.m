function scale_deltas = deltas(config)
%INTERACTIONS.SCALES.DELTAS
    n_scales = config.wave.n_scales;
    distance = config.zli.scale_interaction_distance;
    if config.zli.interaction.scale.enabled && n_scales - distance <= 0
        error('MODEL:scales', ...
            '%i scales is too small, given an interaction distance of %i', ...
            n_scales, distance ...
        )
    end
    zli = config.zli;
    scale_deltas = zli.Delta * model.utils.scale2size(1:config.wave.n_scales, zli.scale2size_type, zli.scale2size_epsilon);
end

