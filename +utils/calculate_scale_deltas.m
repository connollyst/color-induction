function scale_deltas = calculate_scale_deltas(config)
%CALCULATE_SCALE_DELTAS
    zli = config.zli;
    scale_deltas = zli.Delta * utils.scale2size(1:config.wave.n_scales, zli.scale2size_type, zli.scale2size_epsilon);
end

