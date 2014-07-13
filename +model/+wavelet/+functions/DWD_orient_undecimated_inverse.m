function rec = DWD_orient_undecimated_inverse(w, c)
    n_scales = size(c, 4);
    rec      = c(:,:,:,n_scales);
    for s = n_scales:-1:1
        % TODO why is this sensitive to the order??
        %rec = rec + w(:,:,:,s,1) + w(:,:,:,s,2) + w(:,:,:,s,3);
        rec = rec + w(:,:,:,s,1) + w(:,:,:,s,3) + w(:,:,:,s,2);
    end
end