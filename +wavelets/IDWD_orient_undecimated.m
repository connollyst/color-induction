function rec = IDWD_orient_undecimated(w, c)
    n_scales = size(c, 4);
    rec      = c(:,:,:,n_scales);
    for s = n_scales:-1:1
        rec = rec + w(:,:,:,s,1) + w(:,:,:,s,2) + w(:,:,:,s,3);
    end
end