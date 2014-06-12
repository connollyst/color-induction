function [curv, w, c] = wavelet_decomposition(I, config)
%WAVELET_DECOMPOSITION Decompose the given image(s) with a wavelet.
%   I:      The input image data, a cell array where each element is a 2 or 3
%           dimensional image.
%   config: The configuration data struct.

    n_membr    = config.zli.n_membr;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    n_channels = config.image.n_channels;
    dynamic    = config.compute.dynamic;
    
    curv = cell(n_orients, n_scales, n_membr);

    % Number of wavelet decompositions to perform.
    % If this is not dynamic, we decompose the first frame and duplicate.
    % Otherwise, we expect an frame for each membrane time step.
    if dynamic == 1
        n_iters = n_membr;
    else
        n_iters = 1;
    end
    
    % different wavelet decompositions		
    for i=1:n_iters
        for channel=1:n_channels
            % TODO provide wavelet funciton dynamically
            [w, c] = wavelets.DWD_orient_undecimated(I{i}(:,:,channel), n_scales-1);
            % TODO the w and c returned are just for the last channel..!
            for s=1:n_scales-1
                for o=1:n_orients
                    curv{o,s,i}(:,:,channel) = w{s}(:,:,o);
                end
            end
            % TODO we keep the residual as the extra scale.. sloppy
            curv{1,n_scales,i}(:,:,channel) = c{n_scales-1};
        end
    end
    
    % replicate wavelet planes if static stimulus
    if dynamic ~= 1
        for i=2:n_membr
            for s=1:n_scales
                for o=1:n_orients
                    curv{o,s,i} = curv{o,s,1};
                end
            end
        end
    end
end