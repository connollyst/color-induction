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

function wavelets = decompose(I, n_cols, n_rows, n_channels, config)
    n_scales  = config.wave.n_scales;
    n_orients = config.wave.n_orients;
    wavelets  = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    switch n_orients
        case 1
            wavelets(:,:,:,:,1) = model.data.wavelet.functions.opponent.so(I, config);
        case 3
            wavelets(:,:,:,:,1) = model.data.wavelet.functions.opponent.do_horizontal(I, config);
            wavelets(:,:,:,:,2) = model.data.wavelet.functions.opponent.do_diagonal(I, config);
            wavelets(:,:,:,:,3) = model.data.wavelet.functions.opponent.do_vertical(I, config);
        case 4
            wavelets(:,:,:,:,1) = model.data.wavelet.functions.opponent.do_horizontal(I, config);
            wavelets(:,:,:,:,2) = model.data.wavelet.functions.opponent.do_diagonal(I, config);
            wavelets(:,:,:,:,3) = model.data.wavelet.functions.opponent.do_vertical(I, config);
            wavelets(:,:,:,:,4) = model.data.wavelet.functions.opponent.so(I, config);
        otherwise
            error(['Cannot decompose to ',num2str(n_orients),' opponent orientations']);
    end
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


function validate(I, config)
% Validate the config for either single, double, or both opponent models.
    n_channels   = size(I, 3);
    n_orients    = config.wave.n_orients;
    if n_channels ~= 3
        error('Expected RGB input image for opponent color processing.');
    end
    if config.rf.single && config.rf.double
        logger.log('Processing single & double opponent model.', config);
        if n_orients ~= 4
            error(['Expected 4 decomposition orientations for '         ...
                   'simultaneous single and double opponent model, '    ...
                   'found: ',num2str(n_orients)]);
        end
    else
        if config.rf.single
            logger.log('Processing single opponent model.', config);
            if n_orients ~= 1
                error(['Expected 1 decomposition orientations for '     ...
                       'single opponent model, found: ',num2str(n_orients)]);
            end
        else
            if config.rf.double
                logger.log('Processing double opponent model.', config);
                if n_orients ~= 3
                    error(['Expected 3 decomposition orientations for ' ...
                           'double opponent model, found: ',num2str(n_orients)]);
                end
            else
                error(['Expected either single or double opponent '     ...
                       'modelling enabled for "opponent" transform.']);
            end
        end
    end
end