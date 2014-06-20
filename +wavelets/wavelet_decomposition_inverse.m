function I_out = wavelet_decomposition_inverse(wavelet, residual, config)
%WAVELET_DECOMPOSITION_INVERSE Perform the inverse wavelet transform
% N.B.: we only perform the inverse wavelet transform of the frames used for computing the
% mean, and NOT of all the sequence!
    % number of frames (among the last ones) we use when we consider the mean
    n_membr = config.zli.n_membr;
    I_out   = cell(n_membr,1);
    for t=1:n_membr
        w = wavelet{t};
        % c = curv_final(1:n_scales-1, n_scales, t);
        c = residual{t};
        I_out{t} = wavelets.IDWD_orient_undecimated(w, c);
    end
end