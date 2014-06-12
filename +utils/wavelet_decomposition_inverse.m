function img_out = wavelet_decomposition_inverse(curv_final, w, c, config)
%WAVELET_DECOMPOSITION_INVERSE Perform the inverse wavelet transform
% N.B.: we only perform the inverse wavelet transform of the frames used for computing the
% mean, and NOT of all the sequence!
    % number of frames (among the last ones) we use when we consider the mean
    n_membr    = config.zli.n_membr;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    ff_ini     = 1;
    ff_fin     = n_membr;
    ff_length  = ff_fin - ff_ini + 1;
    img_out    = zeros(n_cols, n_rows, ff_length);
    for ff=ff_ini:ff_fin
       for s=1:n_scales-1
            for o=1:n_orients
                % TODO reconstruct all channels
                w{s}(:,:,o) = curv_final{o,s,ff}(:,:,1);
            end
       end
       c{n_scales-1}   = curv_final{1,n_scales,ff};
       img_out(:,:,ff) = wavelets.IDWD_orient_undecimated(w,c);
    end
end

