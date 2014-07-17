function scale_deltas = deltas(config)
%INTERACTIONS.SCALES.DELTAS
    zli = config.zli;
    scale_deltas = zli.Delta * model.utils.scale2size(1:config.wave.n_scales, zli.scale2size_type, zli.scale2size_epsilon);
end

