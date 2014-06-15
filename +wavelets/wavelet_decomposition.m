function [curv, w, c] = wavelet_decomposition(I, config)
%WAVELET_DECOMPOSITION Decompose the given image(s) with a wavelet.
%   I:      The input image data, a cell array where each element is a 2 or 3
%           dimensional image.
%   config: The configuration data struct.

    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    n_membr    = config.zli.n_membr;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    dynamic    = config.compute.dynamic;

    % Number of wavelet decompositions to perform.
    % If this is not dynamic, we decompose the first frame and duplicate.
    % Otherwise, we expect an frame for each membrane time step.
    if dynamic == 1
        n_iters = n_membr;
    else
        n_iters = 1;
    end
    
    curv = cell(n_membr, 1);
    % different wavelet decompositions		
    for i=1:n_iters
        % TODO provide wavelet funciton dynamically
        [w, c] = wavelets.DWD_orient_undecimated(I{i}, n_scales-1);
        curv{i} = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
        curv{i}(:,:,:,1:n_scales-1,:) = w;
        % TODO we keep the residual as the extra scale.. sloppy
        curv{i}(:,:,:,3,1:n_scales-1) = c;
    end
    
    % replicate wavelet planes if static stimulus
    if dynamic ~= 1
        for i=2:n_membr
            curv{i} = curv{1};
        end
    end
end