function [wavelet, residual] = decomposition(I, config)
%WAVELET.DECOMPOSITION Decompose the given image(s) with a wavelet.
%   I:      The input image data, a cell array where each element is a 2 or 3
%           dimensional image.
%   config: The configuration data struct.

    n_images = length(I);
    n_membr  = config.zli.n_membr;
    n_scales = config.wave.n_scales;

    if n_images > n_membr
        error('There are more images than time steps.')
    end
    
    wavelet  = cell(n_membr, 1);
    residual = cell(n_membr, 1);
    for i=1:n_images
        % TODO provide wavelet function based on configuration
        [wavelet{i}, residual{i}] = model.wavelet.functions.DWD_orient_undecimated(I{i}, n_scales);
    end
    
    % If necessary, replicate wavelet planes if static stimulus
    for a=n_images:n_membr-1
        b = mod(a, n_images)+1;
        wavelet{a+1}  = wavelet{b};
        residual{a+1} = residual{b};
    end
end