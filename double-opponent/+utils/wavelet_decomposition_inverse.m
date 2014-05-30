function img_out = wavelet_decomposition_inverse(img, w, c, curv_final, n_membr, n_scales)
%WAVELET_DECOMPOSITION_INVERSE Perform the inverse wavelet transform
% N.B.: we only perform the inverse wavelet transform of the frames used for computing the
% mean, and NOT of all the sequence!
    % number of frames (among the last ones) we use when we consider the mean
    img_width  = size(img,1);
    img_height = size(img,2);
    ff_ini     = 1;
    ff_fin     = n_membr;
    ff_length  = ff_fin - ff_ini + 1;
    img_out    = zeros(img_width, img_height, ff_length);
    for ff=ff_ini:ff_fin
       for s=1:n_scales-1
            for o=1:3
                w{s}(:,:,o) = curv_final{ff}{s}{o};
            end
       end
       c{n_scales-1}   = curv_final{ff}{n_scales}{1};
       img_out(:,:,ff) = wavelets.Ia_trous(w,c);
    end
end

