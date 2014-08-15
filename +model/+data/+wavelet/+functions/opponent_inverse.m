function recovered = opponent_inverse(wavelets, residuals)
    n_scales  = size(residuals, 4);
    n_orients = size(wavelets, 5);
    recovered = residuals(:,:,:,n_scales);
    for s = n_scales:-1:1
        for o=1:n_orients
            recovered = recovered + wavelets(:,:,:,s,o);
        end
    end
end