function rec = IDWD_orient_undecimated(w, c)
    n_scales = length(c);
    rec      = c{1,n_scales};
    for s = n_scales:-1:1
        rec = rec + w{1,s} + w{2,s} + w{3,s};
    end
end
