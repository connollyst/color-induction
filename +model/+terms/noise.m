function N = noise(config)
%GENERATE_NOISE Generate neural noise.
    if config.zli.add_neural_noise
        N = 0.2 * model.utils.rand(config) - 0.5;
    else
        N = model.utils.zeros(config);
    end
end