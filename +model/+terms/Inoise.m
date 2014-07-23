function N = Inoise(config)
%MODEL.TERMS.INOISE Generate zero mean, random, neural noise.
%                   p.209, Li 1999
    if config.zli.add_neural_noise
        N = 0.2 * model.utils.rand(config) - 0.5;
    else
        N = model.utils.zeros(config);
    end
end