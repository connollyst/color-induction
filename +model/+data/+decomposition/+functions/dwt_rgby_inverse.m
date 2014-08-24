function recovered = dwt_rgby_inverse(wavelets, residuals)
    n_scales  = size(residuals, 4);
    recovered = residuals(:,:,:,n_scales);
    for s = n_scales:-1:1
        switch size(wavelets, 5)
            case 1
                recovered = recovered       ...
                    + wavelets(:,:,:,s,1);      % non-oriented
            case 3
                recovered = recovered       ...
                    + wavelets(:,:,:,s,1)   ... % horizontal
                    + wavelets(:,:,:,s,2)   ... % diagonal
                    + wavelets(:,:,:,s,3);      % vertical
            case 4
                recovered = recovered       ...
                    + wavelets(:,:,:,s,1)   ... % horizontal
                    + wavelets(:,:,:,s,2)   ... % diagonal
                    + wavelets(:,:,:,s,3)   ... % vertical
                    + wavelets(:,:,:,s,4);      % non-oriented
        end
    end
end