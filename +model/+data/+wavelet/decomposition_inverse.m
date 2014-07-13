function I_out = decomposition_inverse(wavelets, residuals, config)
%WAVELET.DECOMPOSITION_INVERSE Perform the inverse wavelet transform
% N.B.: we only perform the inverse wavelet transform of the frames used for computing the
% mean, and NOT of all the sequence!
    % number of frames (among the last ones) we use when we consider the mean
    n_membr = config.zli.n_membr;
    I_out   = cell(n_membr,1);
    inverse_transform = str2func(['model.data.wavelet.functions.',config.wave.transform,'_inverse']);
    for t=1:n_membr
        wavelet  = wavelets{t};
        residual = residuals{t};
        I_out{t} = inverse_transform(wavelet, residual);
    end
end