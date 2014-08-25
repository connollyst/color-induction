function recovered = dwt_inverse(wavelets, residuals)
    n_scales  = size(residuals, 4);
    recovered = residuals(:,:,:,n_scales);
    for s = n_scales:-1:1
        switch size(wavelets, 5)
            case 1
                recovered = recovered       ...
                    + wavelets(:,:,:,s,1);      % non-oriented
            case 3
                % TODO why is this sensitive to the order?? (floating rounding error)
                recovered = recovered       ...
                    + wavelets(:,:,:,s,1)   ... % horizontal
                    + wavelets(:,:,:,s,3)   ... % vertical
                    + wavelets(:,:,:,s,2);      % diagonal
            case 4
                recovered = recovered       ...
                    + wavelets(:,:,:,s,1)   ... % horizontal
                    + wavelets(:,:,:,s,2)   ... % diagonal
                    + wavelets(:,:,:,s,3)   ... % vertical
                    + wavelets(:,:,:,s,4);      % non-oriented
        end
    end
end