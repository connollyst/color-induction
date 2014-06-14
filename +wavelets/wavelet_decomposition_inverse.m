function img_out = wavelet_decomposition_inverse(curv_final, config)
%WAVELET_DECOMPOSITION_INVERSE Perform the inverse wavelet transform
% N.B.: we only perform the inverse wavelet transform of the frames used for computing the
% mean, and NOT of all the sequence!
    % number of frames (among the last ones) we use when we consider the mean
    n_membr      = config.zli.n_membr;
    n_scales     = config.wave.n_scales;
    n_cols       = config.image.width;
    n_rows       = config.image.height;
    n_channels   = config.image.n_channels;
    img_out      = cell(n_membr,1);
    [img_out{:}] = deal(zeros(n_cols, n_rows, n_channels));
    for t=1:n_membr
        w = curv_final(:,1:n_scales-1,t);
        c = curv_final(1:n_scales-1, n_scales, t);
        img_out{t} = wavelets.IDWD_orient_undecimated(w,c);
    end
end