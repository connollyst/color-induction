function [J_fft, W_fft] = to_fft(J, W, interactions, config)
%TO_FFT Summary of this function goes here
%   Detailed explanation goes here

    n_cols          = config.image.width;
    n_rows          = config.image.height;
    n_scales        = config.wave.n_scales;
    n_orients       = config.wave.n_orients;
    scale_deltas    = interactions.scale_deltas;
    scale_diameters = interactions.scale_diameters;
    
    J_fft  = cell(n_scales, 1);
    W_fft  = cell(n_scales, 1);
    
    for s=1:n_scales
        % a matrix for each scale
        % fft for speed (convolutions are computed in another space)
        J_fft{s} = zeros(n_cols+2*scale_deltas(s), n_rows+2*scale_deltas(s), 1, n_orients, n_orients);
        W_fft{s} = zeros(n_cols+2*scale_deltas(s), n_rows+2*scale_deltas(s), 1, n_orients, n_orients);
        for ov=1:n_orients
            for oc=1:n_orients
                if config.compute.avoid_circshift_fft==1
                    % FFT that does not require circshift (by far better)
                    padsize = [n_cols+2*scale_deltas(s)-scale_diameters(s),n_rows+2*scale_deltas(s)-scale_diameters(s)];
                    J_circ = padarray(J{s}(:,:,1,ov,oc), padsize, 0,'post');
                    W_circ = padarray(W{s}(:,:,1,ov,oc), padsize, 0,'post');
                    J_circ = circshift(J_circ, -[scale_deltas(s) scale_deltas(s)]);
                    W_circ = circshift(W_circ, -[scale_deltas(s) scale_deltas(s)]);
                    J_fft{s}(:,:,1,ov,oc) = fftn(J_circ);
                    W_fft{s}(:,:,1,ov,oc) = fftn(W_circ);
                else
                    % FFT that requires circshift
                    J_fft{s}(:,:,1,ov,oc) = fftn(J{s}(:,:,1,ov,oc),[n_cols+2*scale_deltas(s),n_rows+2*scale_deltas(s)]);
                    W_fft{s}(:,:,1,ov,oc) = fftn(W{s}(:,:,1,ov,oc),[n_cols+2*scale_deltas(s),n_rows+2*scale_deltas(s)]);
                end
            end
        end
    end
end

