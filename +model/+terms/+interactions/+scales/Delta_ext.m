function d = Delta_ext(scale_distance, scale_deltas, config)
    n_scales = config.wave.n_scales;
    d = zeros(1, n_scales+scale_distance*2);
    d(scale_distance+1:n_scales+scale_distance)            = scale_deltas;
    d(1:scale_distance)                                    = scale_deltas(1);
    d(n_scales+scale_distance+1:n_scales+scale_distance*2) = scale_deltas(n_scales);
end