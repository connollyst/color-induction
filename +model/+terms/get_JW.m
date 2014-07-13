function JW = get_JW(interactions, config)
%GET_JW Return J (excitation) & W (inhibition) masks defined by Z. Li 1999.

    % TODO perhaps J & W don't need the interactions?
    scale_deltas   = interactions.scale_deltas;
    scale_distance = interactions.scale_distance;
    
    zli        = config.zli;
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    transform  = config.wave.transform;
    % maximum diameter of the area of influence
    diameter   = 2*scale_deltas+1;
    all_J      = cell(n_scales, 1);
    all_W      = cell(n_scales, 1);
    all_J_fft  = cell(n_scales, 1);
    all_W_fft  = cell(n_scales, 1);
   
    for s=1:n_scales
        % TODO J & W should NOT be sized by the scale!
        all_J{s} = zeros(diameter(s), diameter(s), n_orients, n_orients);
        all_W{s} = zeros(diameter(s), diameter(s), n_orients, n_orients);
        % TODO This assumes that the central cell is orientation selective.
        %      If the cell is not oriented, J & W should be... circular?
        for o=1:n_orients
            [all_J{s}(:,:,:,o), all_W{s}(:,:,:,o)] = ...
                model.utils.get_Jithetajtheta_v0_4(s, n_orients, o, scale_deltas(s), transform, zli);
        end
    end

    for s=1:n_scales
        if scale_distance > 0
            % Why doe we have a scale dimension of n=1??
            J = zeros(diameter(s), diameter(s), 1, n_orients, n_orients);
            W = zeros(diameter(s), diameter(s), 1, n_orients, n_orients);
            J(:,:,1,:,:) = 1 * all_J{s}(:,:,:,:);
            W(:,:,1,:,:) = 1 * all_W{s}(:,:,:,:);
            all_J{s} = J;
            all_W{s} = W;
        end
        % a matrix for each scale
        % fft for speed (convolutions are computed in another space)
        all_J_fft{s} = zeros(n_cols+2*scale_deltas(s), n_rows+2*scale_deltas(s), 1, n_orients, n_orients);
        all_W_fft{s} = zeros(n_cols+2*scale_deltas(s), n_rows+2*scale_deltas(s), 1, n_orients, n_orients);
        all_W_fft{s} = zeros(n_cols+2*scale_deltas(s), n_rows+2*scale_deltas(s));
        for ov=1:n_orients
            for oc=1:n_orients
                if config.compute.avoid_circshift_fft==1
                    % FFT that does not require circshift (by far better)
                    padsize = [n_cols+2*scale_deltas(s)-diameter(s),n_rows+2*scale_deltas(s)-diameter(s)];
                    J_circ = padarray(all_J{s}(:,:,1,ov,oc), padsize, 0,'post');
                    W_circ = padarray(all_W{s}(:,:,1,ov,oc), padsize, 0,'post');
                    J_circ = circshift(J_circ, -[scale_deltas(s) scale_deltas(s)]);
                    W_circ = circshift(W_circ, -[scale_deltas(s) scale_deltas(s)]);
                    all_J_fft{s}(:,:,1,ov,oc) = fftn(J_circ);
                    all_W_fft{s}(:,:,1,ov,oc) = fftn(W_circ);
                else
                    % FFT that requires circshift
                    all_J_fft{s}(:,:,1,ov,oc) = fftn(all_J{s}(:,:,1,ov,oc),[n_cols+2*scale_deltas(s),n_rows+2*scale_deltas(s)]);
                    all_W_fft{s}(:,:,1,ov,oc) = fftn(all_W{s}(:,:,1,ov,oc),[n_cols+2*scale_deltas(s),n_rows+2*scale_deltas(s)]);
                end
            end
        end
    end
    
    JW = struct;
    JW.J = all_J;
    JW.W = all_W;
    JW.J_fft = all_J_fft;
    JW.W_fft = all_W_fft;
end