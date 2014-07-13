function [gx_final] = process_induction_model(Iitheta, config)
%PROCESS_INDUCTION_MODEL Apply induction model to input data.
%   From NCZLd_channel_ON_OFF_v1_1.m to all the functions for implementing
%   Li 1999.
%   Iitheta: Cell struct of input stimuli at each membrane time step, eg:
%            Iitheta{t}(c,r,d,s,o) is the column (c), row (r) and color
%            dimension (d) of image (t), decomposed at scale (s) and
%            orientation (o).
%   config:  The model configuration struct array
%
%   gx_final:   the excitation membrane potentials
    
    validate_input(config)

    % Initialize output membrane potentials
    gx_final     = utils.initialize_data(config);
    gy_final     = utils.initialize_data(config);
    % Normalization
    Iitheta      = model.utils.normalize_input(Iitheta, config);
    norm_masks   = model.terms.get_normalization_masks(config);
    % Prepare orientation/scale/color interactions for x_ei
    interactions = model.terms.get_interactions(config);
    % Prepare J & W: the excitatory and inhibitory masks
    JW           = model.terms.get_JW(interactions.scale_distance, config);
    % Set the initial x (excitation) & y (inhibition) activity
    [x, y]       = initialize_xy(Iitheta, config);
    % Run recurrent network: the loop over time
    for t=1:config.zli.n_membr  % membrane time
        logger.log('Membrane time step: %i/%i\n', t, config.zli.n_membr, config);
        tic
        for t_iter=1:config.zli.n_iter  % from the differential equation (Euler!)
            logger.log('Membrane interation: %i/%i\n', t_iter, config.zli.n_iter, config);
            tIitheta = Iitheta{t};
            [x, y] = model.process_update_xy(tIitheta, x, y, JW, norm_masks, interactions, config);
        end
        if config.display.logging
            toc
        end
        % TODO we are bypassing initialization, no?
        gx_final{t} = model.terms.gx(x);
        % TODO we are not using gy_final..?
        gy_final{t} = model.terms.gy(y);    
    end
end

function validate_input(config)
    if config.image.width <= 10 || config.image.height <= 10
       error('Bad stimulus dimensions: the toroidal boundary conditions are ill-defined.');
    end
end

function [x, y] = initialize_xy(Iitheta, config)
%INITIALIZE_XY Initialize the initial stimulus & inhibition to the system.

    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    n_orients  = config.wave.n_orients;
    n_scales   = config.wave.n_scales;
    
    % x is initialized as the visual stimulus (p.192)
    x = Iitheta{1}; % use first time frame
    
    % y is initialized with zero activity
    y = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
end
