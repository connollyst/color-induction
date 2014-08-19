function recovered = dwt_rgby_inverse(wavelets, residuals)
    n_scales  = size(residuals, 4);
    recovered = residuals(:,:,:,n_scales);
    for s = n_scales:-1:1
        recovered = recovered + wavelets(:,:,:,s,1) + wavelets(:,:,:,s,2) + wavelets(:,:,:,s,3);
    end
end