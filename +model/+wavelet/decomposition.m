function [wavelet, residual] = decomposition(I, config)
%WAVELET.DECOMPOSITION Decompose the given image(s) with a wavelet.
%   I:      The input image data, a cell array where each element is a 2 or 3
%           dimensional image.
%   config: The configuration data struct.

    n_membr  = config.zli.n_membr;
    n_scales = config.wave.n_scales;
    dynamic  = config.image.dynamic;

    % Number of wavelet decompositions to perform.
    % If this is not dynamic, we decompose the first frame and duplicate.
    % Otherwise, we expect an frame for each membrane time step.
    if dynamic == 1
        n_iters = n_membr;
    else
        n_iters = 1;
    end
    
    wavelet  = cell(n_membr, 1);
    residual = cell(n_membr, 1);
    for i=1:n_iters
        % TODO provide wavelet function based on configuration
        [wavelet{i}, residual{i}] = model.wavelet.functions.DWD_orient_undecimated(I{i}, n_scales);
    end
    
    % replicate wavelet planes if static stimulus
    % TODO we can do this without relying on config.image.dynamic
    if dynamic ~= 1
        for i=2:n_membr
            wavelet{i}  = wavelet{1};
            residual{i} = residual{1};
        end
    end
end