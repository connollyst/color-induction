function filter = half_size_filter(scale_interaction_distance, scale_deltas, config)
    n_scales = config.wave.n_scales;
    filter   = cell(n_scales, 1);
    for s=1:n_scales
        if scale_interaction_distance > 0
            filter{s} = [scale_deltas(s) scale_deltas(s) 0];
        end
    end
end