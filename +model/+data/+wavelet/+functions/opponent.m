function [wavelets, residuals] = opponent(I, config)
%OPPONENT Image decomposition reflective of the chromatic and spatial
%         opponent system in the primate striate cortex.

    validate(I, config);
    
    n_cols     = size(I, 1);
    n_rows     = size(I, 2);
    n_channels = 4;     % RGBY
    
    wavelets   = decompose(I, n_cols, n_rows, n_channels, config);
    residuals  = r(I, wavelets, n_cols, n_rows, n_channels, config);
end

function validate(I, config)
    n_channels = size(I, 3);
    if n_channels ~= 3
        error('Expected RGB input image for opponent color processing.');
    end
    n_orients = config.wave.n_orients;
    switch n_orients
        case 1
            logger.log('Processing single opponent model.', config);
        case 3
            logger.log('Processing double opponent model.', config);
        case 4
            logger.log('Processing single & double opponent model.', config);
        otherwise
            error(['Expected 1, 3, or 4 orientations for opponent '     ...
                   'model, found: ',n_orients]);
    end
end

function wavelets = decompose(I, n_cols, n_rows, n_channels, config)
    n_scales  = config.wave.n_scales;
    n_orients = config.wave.n_orients;
    wavelets  = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    o         = 1;
    if n_orients >= 3
        wavelets(:,:,:,:,1) = model.data.wavelet.functions.opponent.do_horizontal(I, config);
        wavelets(:,:,:,:,2) = model.data.wavelet.functions.opponent.do_diagonal(I, config);
        wavelets(:,:,:,:,3) = model.data.wavelet.functions.opponent.do_vertical(I, config);
        o = o + 3;
    end
    if n_orients == 1 || n_orients == 4
        wavelets(:,:,:,:,o) = model.data.wavelet.functions.opponent.so(I, config);
    end
    % TODO add concentric double opponent cells?
end

function residuals = r(I, wavelets, n_cols, n_rows, n_channels, config)
    n_scales  = config.wave.n_scales;
    n_orients = config.wave.n_orients;
    residuals = zeros(n_cols, n_rows, n_channels, n_scales);
    rgby      = model.data.wavelet.functions.opponent.rgby(I);
    for s=1:n_scales
        for o=1:n_orients
            rgby = rgby - wavelets(:,:,:,s,o);
        end
        residuals(:,:,:,s) = rgby;
    end
end