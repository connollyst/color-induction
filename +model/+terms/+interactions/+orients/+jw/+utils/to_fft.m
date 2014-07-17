function [filter_fft] = to_fft(filter, scale_interactions, config)
%TO_FFT Summary of this function goes here
%   Detailed explanation goes here

    n_cols          = config.image.width;
    n_rows          = config.image.height;
    n_scales        = config.wave.n_scales;
    n_orients       = config.wave.n_orients;
    scale_deltas    = scale_interactions.deltas;
    scale_diameters = scale_interactions.diameters;
    
    filter_fft  = cell(n_scales, 1);
    
    for s=1:n_scales
        % a matrix for each scale
        % fft for speed (convolutions are computed in another space)
        filter_fft{s} = zeros(n_cols+2*scale_deltas(s), n_rows+2*scale_deltas(s), 1, n_orients, n_orients);
        for ov=1:n_orients
            for oc=1:n_orients
                if config.compute.avoid_circshift_fft==1
                    % FFT that does not require circshift (by far better)
                    padsize = [n_cols+2*scale_deltas(s)-scale_diameters(s),n_rows+2*scale_deltas(s)-scale_diameters(s)];
                    filter_circ = padarray(filter{s}(:,:,1,ov,oc), padsize, 0,'post');
                    filter_circ = circshift(filter_circ, -[scale_deltas(s) scale_deltas(s)]);
                    filter_fft{s}(:,:,1,ov,oc) = fftn(filter_circ);
                else
                    % FFT that requires circshift
                    filter_fft{s}(:,:,1,ov,oc) = fftn(filter{s}(:,:,1,ov,oc),[n_cols+2*scale_deltas(s),n_rows+2*scale_deltas(s)]);
                end
            end
        end
    end
end

