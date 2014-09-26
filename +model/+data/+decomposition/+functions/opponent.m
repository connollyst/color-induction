function [components, residuals] = opponent(rgb, config)
%OPPONENT Image decomposition reflective of the chromatic and spatial
%         opponent system in the primate striate cortex. Gaussians are used
%         to model the receptive fields in the RGB channels and the signals
%         are combined to obtain opponent colors.
%         For moreinfo , refer to the Section titled "Opponent Processing
%         of Neural Receptive Fields" in the Connolly thesis.
    validate(rgb, config);
    components = decompose(rgb, config);
    residuals  = subtract(rgb, components, config);
end

function components = decompose(rgb, config)
    n_cols     = size(rgb, 1);
    n_rows     = size(rgb, 2);
    n_channels = 6;     % LDRGBY
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    components = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    switch n_orients
        case 1
            components(:,:,:,:,1) = model.data.decomposition.functions.opponent.so(rgb, config);
        case 3
            components(:,:,:,:,1) = model.data.decomposition.functions.opponent.do_horizontal(rgb, config);
            components(:,:,:,:,2) = model.data.decomposition.functions.opponent.do_diagonal(rgb, config);
            components(:,:,:,:,3) = model.data.decomposition.functions.opponent.do_vertical(rgb, config);
        case 4
            components(:,:,:,:,1) = model.data.decomposition.functions.opponent.do_horizontal(rgb, config);
            components(:,:,:,:,2) = model.data.decomposition.functions.opponent.do_diagonal(rgb, config);
            components(:,:,:,:,3) = model.data.decomposition.functions.opponent.do_vertical(rgb, config);
            components(:,:,:,:,4) = model.data.decomposition.functions.opponent.so(rgb, config);
        otherwise
            error(['Cannot decompose to ',num2str(n_orients),' opponent orientations.']);
    end
end

function residuals = subtract(rgb, components, config)
    n_cols     = size(rgb, 1);
    n_rows     = size(rgb, 2);
    n_channels = 6;             % LDRGBY
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    residuals  = zeros(n_cols, n_rows, n_channels, n_scales);
    LDRGBY     = model.data.rf.transform(rgb, config);
    for s=1:n_scales
        for o=1:n_orients
            LDRGBY = LDRGBY - components(:,:,:,s,o);
        end
        residuals(:,:,:,s) = LDRGBY;
    end
end


function validate(I, config)
% Validate the config for either single, double, or both opponent models.
    n_channels   = size(I, 3);
    n_orients    = config.wave.n_orients;
    if n_channels ~= 3
        error('Expected RGB input image for opponent color processing.');
    end
    if config.rf.so.enabled && config.rf.do.enabled
        logger.log('Processing single & double opponent model.', config);
        if n_orients ~= 4
            error(['Expected 4 decomposition orientations for '         ...
                   'simultaneous single and double opponent model, '    ...
                   'found: ',num2str(n_orients)]);
        end
    else
        if config.rf.so.enabled
            logger.log('Processing single opponent model.', config);
            if n_orients ~= 1
                error(['Expected 1 decomposition orientations for '     ...
                       'single opponent model, found: ',num2str(n_orients)]);
            end
        else
            if config.rf.do.enabled
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