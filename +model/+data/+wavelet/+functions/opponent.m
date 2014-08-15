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
    double    = config.rf.double_enabled;
    single    = config.rf.single_enabled;
    switch n_orients
        case 1
            if double || ~single
                error(['Expected spatial opponency disabled and color ' ...
                       'opponency enabled for ',num2str(n_orients),     ...
                       ' orients.']);
            end
        case 3
            if ~double || single
                error(['Expected spatial opponency enabled and color '  ...
                       'opponency disabled for ',num2str(n_orients),    ...
                       ' orients.']);
            end
        case 4
            if ~double || ~single
                error(['Expected spatial opponency and color opponency '...
                       'enabled for ',num2str(n_orients),' orients.']);
            end
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
    if config.rf.double_enabled
        wavelets(:,:,:,:,1) = model.data.wavelet.functions.opponent.do_horizontal(I, config);
        wavelets(:,:,:,:,2) = model.data.wavelet.functions.opponent.do_diagonal(I, config);
        wavelets(:,:,:,:,3) = model.data.wavelet.functions.opponent.do_vertical(I, config);
        o = o + 3;
    end
    if config.rf.single_enabled
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