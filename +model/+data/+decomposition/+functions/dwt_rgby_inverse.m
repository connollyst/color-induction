function recovered = dwt_rgby_inverse(wavelets, residuals)
    n_scales  = size(residuals, 4);
    recovered = residuals(:,:,:,n_scales);
    for s = n_scales:-1:1
        recovered = recovered       ...
            + wavelets(:,:,:,s,1)   ... % horizontal
            + wavelets(:,:,:,s,2)   ... % diagonal
            + wavelets(:,:,:,s,3)   ... % vertical
            + wavelets(:,:,:,s,4);      % non-oriented
    end
end