function img_out = wavelet_decomposition_inverse(curv_final, w, c, config)
%WAVELET_DECOMPOSITION_INVERSE Perform the inverse wavelet transform
% N.B.: we only perform the inverse wavelet transform of the frames used for computing the
% mean, and NOT of all the sequence!
    % number of frames (among the last ones) we use when we consider the mean
    n_membr      = config.zli.n_membr;
    n_scales     = config.wave.n_scales;
    n_orients    = config.wave.n_orients;
    n_cols       = config.image.width;
    n_rows       = config.image.height;
    n_channels   = config.image.n_channels;
    img_out      = cell(n_membr,1);
    [img_out{:}] = deal(zeros(n_cols, n_rows, n_channels));
    for t=1:n_membr
       for s=1:n_scales-1   % TODO n_sclaes was modified in NCZLd_channel_ON_OFF_v1_1!!
            for o=1:n_orients
                w{o,s} = curv_final{o,s,t};
            end
       end
       c{n_scales-1}  = curv_final{1,n_scales,t};
       img_out{t} = wavelets.IDWD_orient_undecimated(w,c);
    end
end