function [gx_final] = Rmodelinductiond_v0_3_2(Iitheta, config)
%RMODELINDUCTIOND_V0_3_2 Apply induction model to input data.
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
    
    % Get the configuration parameters
    wave         = config.wave;
    zli          = config.zli;
    n_scales     = wave.n_scales;
    n_membr      = zli.n_membr;
    n_iter       = zli.n_iter;
    scale_deltas = zli.Delta * utils.scale2size(1:n_scales, zli.scale2size_type, zli.scale2size_epsilon);
    % Initialize output membrane potentials
    gx_final     = utils.initialize_data(config);
    gy_final     = utils.initialize_data(config);
    % Normalization
    Iitheta      = model.normalize_input(Iitheta, config);
    norm_masks   = model.terms.get_normalization_masks(config);
    % Prepare orientation/scale/color interactions for x_ei
    interactions = model.terms.get_interactions(scale_deltas, config);
    % Prepare J & W: the excitatory and inhibitory masks
    JW           = model.terms.get_JW(scale_deltas, interactions.scale_distance, config);
    % Set the initial x (excitation) & y (inhibition) activity
    [x, y]       = initialize_input(Iitheta, config);
    % Run recurrent network: the loop over time
    for t=1:n_membr  % membrane time
        logger.log('Membrane time step: %i/%i\n', t, n_membr, config);
        tic
        for t_iter=1:n_iter  % from the differential equation (Euler!)
            logger.log('Membrane interation: %i/%i\n', t_iter, n_iter, config);
            tIitheta = Iitheta{t};
            [x, y] = model.process.UpdateXY(...
                        tIitheta, x, y, scale_deltas, JW,...
                        norm_masks, interactions, config...
                     );
        end
        if config.display.logging
            toc
        end
        % TODO we are bypassing initialization, no?
        gx_final{t} = model.terms.gx(x);
        gy_final{t} = model.terms.gy(y);
        % Move the diagonal orientation back to the 3rd position
        % TODO why..?
        gx_final{t}(:,:,:,:,[2,3]) = gx_final{t}(:,:,:,:,[3,2]);
    end
end

function validate_input(config)
    if config.image.width <= 10 || config.image.height <= 10
       error('Bad stimulus dimensions: the toroidal boundary conditions are ill-defined.');
    end
end

function [x, y] = initialize_input(Iitheta, config)
%INITIALIZE_INPUT Initialize the initial stimulus to the system.
%   x and y are two dimensional cell arrays of n-dimensional images. The
%   first cell dimension is the scale of the wavelet decomposition
%   (neural frequency preference) and the second cell dimension is the
%   orientation of the wavelet decomposition (neural orientation
%   preference).
%
%   x: Cell array of the initial exitation stimulus
%   y: Cell array of the initial inhibition stimulus

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
