function JW = get_JW(M, N, K, Delta, radius_sc, config)
%GET_JW Return J (excitation) & W (inhibition) masks defined by Z. Li 1999.
%   Detailed explanation goes here

    zli       = config.zli;
    wave      = config.wave;
    n_scales  = wave.n_scales;
    % maximum diameter of the area of influence
    diameter  = 2*Delta+1;
    all_J     = cell(n_scales,1);
    all_W     = cell(n_scales,1);
    all_J_fft = cell(n_scales,1);
    all_W_fft = cell(n_scales,1);
   
    for s=1:n_scales
        % TODO J & W should NOT be sized by the scale!
        all_J{s} = zeros(diameter(s), diameter(s), K, K);
        all_W{s} = zeros(diameter(s), diameter(s), K, K);
        % TODO This assumes that the central cell is orientation selective.
        %      If the cell is not oriented, J & W should be... circular?
        for o=1:K
            [all_J{s}(:,:,:,o), all_W{s}(:,:,:,o)] = ...
                model.get_Jithetajtheta_v0_4(s, K, o, Delta(s), wave.multires, zli);
        end
    end

    for s=1:n_scales
        if radius_sc >0
            J = zeros(diameter(s), diameter(s), 1, K, K);
            W = zeros(diameter(s), diameter(s), 1, K, K);
            J(:,:,1,:,:) = 1*all_J{s}(:,:,:,:);
            W(:,:,1,:,:) = 1*all_W{s}(:,:,:,:);
            all_J{s} = J;
            all_W{s} = W;
        end
        % a matrix for each scale
        % fft for speed (convolutions are computed in another space)
        if config.compute.use_fft
            all_J_fft{s} = zeros(M+2*Delta(s), N+2*Delta(s), 1, K, K);
            all_W_fft{s} = zeros(M+2*Delta(s), N+2*Delta(s), 1, K, K);
            all_W_fft{s} = zeros(M+2*Delta(s), N+2*Delta(s));
            for ov=1:K
                for oc=1:K
                    if config.compute.avoid_circshift_fft==1
                        % FFT that does not require circshift (by far better)
                        padsize = [M+2*Delta(s)-diameter(s),N+2*Delta(s)-diameter(s)];
                        J_circ = padarray(all_J{s}(:,:,1,ov,oc), padsize, 0,'post');
                        W_circ = padarray(all_W{s}(:,:,1,ov,oc), padsize, 0,'post');
                        J_circ = circshift(J_circ, -[Delta(s) Delta(s)]);
                        W_circ = circshift(W_circ, -[Delta(s) Delta(s)]);
                        all_J_fft{s}(:,:,1,ov,oc) = fftn(J_circ);
                        all_W_fft{s}(:,:,1,ov,oc) = fftn(W_circ);
                    else
                        % FFT that requires circshift
                        all_J_fft{s}(:,:,1,ov,oc) = fftn(all_J{s}(:,:,1,ov,oc),[M+2*Delta(s),N+2*Delta(s)]);
                        all_W_fft{s}(:,:,1,ov,oc) = fftn(all_W{s}(:,:,1,ov,oc),[M+2*Delta(s),N+2*Delta(s)]);
                    end
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