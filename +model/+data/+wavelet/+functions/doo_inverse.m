function rec = doo_inverse(wavelets, residuals)
    n_scales = size(residuals, 4);
    rec      = residuals(:,:,:,n_scales);
    for s = n_scales:-1:1
        rec = rec + wavelets(:,:,:,s,1) + wavelets(:,:,:,s,2) + wavelets(:,:,:,s,3);
    end
end