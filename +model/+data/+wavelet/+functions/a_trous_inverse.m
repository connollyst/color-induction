function rec = a_trous_inverse(wavelets, residuals)
    n_scales = size(residuals, 4);
    rec      = residuals(:,:,:,n_scales);
    for s = n_scales:-1:1
        rec = rec + wavelets(:,:,:,s);
    end
end
