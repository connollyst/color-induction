function [wavelets, residuals] = decomposition(I, config)
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
    
    [wavelets, residuals] = deal(cell(n_membr, 1));
    
    transform = str2func(['model.data.wavelet.functions.', config.wave.transform]);
    for i=1:n_images
        [wavelets{i}, residuals{i}] = transform(I{i}, n_scales);
    end
    
    % If necessary, replicate wavelet & residual planes
    for a=n_images:n_membr-1
        b = mod(a, n_images)+1;
        wavelets{a+1}  = wavelets{b};
        residuals{a+1} = residuals{b};
    end
end