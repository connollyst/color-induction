function I_out = invert(wavelets, residuals, config)
%DECOMPOSITION.invert Perform the inverse wavelet transform
% Note: we only perform the inverse wavelet transform of the frames used
%       for computing the mean, and NOT of the full sequence.
    n_membr = config.zli.n_membr;
    I_out   = cell(n_membr,1);
    inverse_transform = str2func(['model.data.decomposition.functions.',config.wave.transform,'_inverse']);
    for t=1:n_membr
        I_out{t} = inverse_transform(wavelets{t}, residuals{t});
    end
end