function [gx_final, gy_final] = process_induction(Iitheta, config)
%PROCESS_INDUCTION Apply induction model to input data.
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
    gx_final     = model.utils.cells(config);
    gy_final     = model.utils.cells(config);
    Iitheta      = model.data.normalization.normalize_input(Iitheta, config);
    norm_masks   = model.data.normalization.get_masks(config);
    interactions = model.terms.get_interactions(config);
    [x, y]       = initialize_xy(Iitheta, config);
    for t=1:config.zli.n_membr  % membrane time
        logger.log('Membrane time step: %i/%i\n', t, config.zli.n_membr, config);
        logger.tic(config)
        for t_iter=1:config.zli.n_iter  % from the differential equation (Euler!)
            logger.log('Membrane interation: %i/%i\n', t_iter, config.zli.n_iter, config);
            title  = ['Iteraction ',num2str(t),'x',num2str(t_iter)];
            [x, y] = model.update_xy(Iitheta{t}, x, y, norm_masks, interactions, config, title);
        end
        % TODO we are bypassing initialization, no?
        gx_final{t} = model.terms.gx(x);
        gy_final{t} = model.terms.gy(y);
        logger.toc(config)
    end
end

function validate_input(config)
    if config.image.width <= 10 || config.image.height <= 10
       error('Bad stimulus dimensions: the toroidal boundary conditions are ill-defined.');
    end
    if strcmp(config.zli.ON_OFF,'opponent') && model.data.utils.is_odd(config.image.n_channels)
        error('An even number of color channels are required for color opponency.');
    end
end

function [x, y] = initialize_xy(Iitheta, config)
%INITIALIZE_XY Initialize the initial stimulus & inhibition to the system.
    
    % x is initialized as the visual stimulus (p.192)
    x = Iitheta{1}; % use first time frame
    
    % y is initialized with zero activity
    y = model.utils.zeros(config);
end
