function [wavelets, residuals] = doo(I, config)
%DOO Double opponent (Oriented) decomposition.
    cols     = size(I, 1);
    rows     = size(I, 2);
    channels = 4;     % RGBY
    scales   = config.wave.n_scales;
    
    wavelets   = zeros(cols, rows, channels, scales, 3);
    residuals  = zeros(cols, rows, channels, scales);
    
    wavelets(:,:,:,:,1) = model.data.wavelet.functions.opponent.do_horizontal(I, config);
    wavelets(:,:,:,:,2) = model.data.wavelet.functions.opponent.do_diagonal(I, config);
    wavelets(:,:,:,:,3) = model.data.wavelet.functions.opponent.do_vertical(I, config);
    
    % TODO can we get residuals? what about Y?
end