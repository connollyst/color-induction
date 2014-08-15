function [wavelets, residuals] = doo(I, config)
%DOO Double opponent (Oriented) decomposition.
    n_cols     = size(I, 1);
    n_rows     = size(I, 2);
    n_channels = 4;     % RGBY
    n_scales   = config.wave.n_scales;
    
    wavelets   = zeros(n_cols, n_rows, n_channels, n_scales, 3);
    residuals  = zeros(n_cols, n_rows, n_channels, n_scales);
    
    wavelets(:,:,:,:,1) = model.data.wavelet.functions.opponent.do_horizontal(I, config);
    wavelets(:,:,:,:,2) = model.data.wavelet.functions.opponent.do_diagonal(I, config);
    wavelets(:,:,:,:,3) = model.data.wavelet.functions.opponent.do_vertical(I, config);
    
    rgby = model.data.wavelet.functions.opponent.rgby(I);
    for s=1:n_scales
        rgby = rgby - wavelets(:,:,:,s,1) - wavelets(:,:,:,s,2) - wavelets(:,:,:,s,3);
        residuals(:,:,:,s) = rgby;
    end
end