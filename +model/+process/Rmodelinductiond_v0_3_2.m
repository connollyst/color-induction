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
    
    %% Get the configuration parameters
    wave       = config.wave;
    zli        = config.zli;
    n_scales   = wave.n_scales;
    n_membr    = zli.n_membr;
    n_iter     = zli.n_iter;
    Delta      = zli.Delta * utils.scale2size(1:n_scales, zli.scale2size_type, zli.scale2size_epsilon);
    
    %% Initialize output membrane potentials
    gx_final = utils.initialize_data(config);
    gy_final = utils.initialize_data(config);

    %% Normalization
    Iitheta             = model.normalize_input(Iitheta, config);
    normalization_masks = model.terms.get_normalization_masks(config);

    %% Prepare orientation/scale/color interactions for x_ei
    interactions = model.terms.get_interactions(Delta, config);
    
    %% Prepare J & W: the excitatory and inhibitory masks
    % TODO perhaps J & W don't need the interactions.scale_distance?
    JW = model.terms.get_JW(Delta, interactions.scale_distance, config);

    %% Set the initial x (excitation) & y (inhibition) activity
    [x, y] = initialize_input(Iitheta, config);
    
    %% Run recurrent network: the loop over time
    for t=1:n_membr  % membrane time
        fprintf('Membrane time step: %i/%i\n', t, n_membr);
        tic
        for t_iter=1:n_iter  % from the differential equation (Euler!)
            fprintf('Membrane interation: %i/%i\n', t_iter, n_iter);
            tIitheta = Iitheta{t};
            [x, y] = model.process.UpdateXY(...
                        tIitheta, x, y, Delta, JW,...
                        normalization_masks, interactions, config...
                     );
        end
        toc
        x2 = temp.new_to_old(x); % DELETEME!!
        y2 = temp.new_to_old(y); % DELETEME!!
        % TODO newgx/y should return the scale/orient as a cell array
        x2 = model.terms.newgx(x2);
        y2 = model.terms.newgy(y2);
        x2 = temp.old_to_new(x2); % DELETEME!!
        y2 = temp.old_to_new(y2); % DELETEME!!
        gx_final(:,:,t) = x2;
        gy_final(:,:,t) = y2;
    end

    % Move the diagonal orientation back to the 3rd position
    % TODO why..?
    gx_final([3,2],:,:) = gx_final([2,3],:,:);
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
