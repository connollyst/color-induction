function rec = dwt_inverse(wavelets, residuals)
    n_scales = size(residuals, 4);
    rec      = residuals(:,:,:,n_scales);
    for s = n_scales:-1:1
        % TODO why is this sensitive to the order??
        %rec = rec + w(:,:,:,s,1) + w(:,:,:,s,2) + w(:,:,:,s,3);
        rec = rec + wavelets(:,:,:,s,1) + wavelets(:,:,:,s,3) + wavelets(:,:,:,s,2);
    end
end