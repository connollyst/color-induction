function [gx_final] = Rmodelinductiond_v0_3_2(Iitheta, config)
%RMODELINDUCTIOND_V0_3_2 Apply induction model to input data.
%   From NCZLd_channel_ON_OFF_v1_1.m to all the functions for implementing
%   Li 1999.
%   Iitheta: Cell struct of input stimuli at each membrane time step, eg:
%            Iitheta{o,s,t}(c,r,d) is the column (c), row (r) and color
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
    [gx_final, gy_final] = initialize_output(config);

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
            tIitheta = get_tIitheta(Iitheta, t, config);
            [x, y] = model.process.UpdateXY(...
                        tIitheta, x, y, Delta, JW,...
                        normalization_masks, interactions, config...
                     );
        end
        toc
        % TODO newgx/y should return the scale/orient as a cell array
            % TODO update from {t,s,o} to {o,s,t}
        gx_final{t,:,:} = model.terms.newgx(x);
        gy_final{t,:,:} = model.terms.newgy(y);
    end

    % TODO some kind of normalization specific to 3 orientations, refactor
    for t=1:n_membr
        for s=1:n_scales
            % TODO update from {t,s,o} to {o,s,t}
            gx_final_2 = gx_final{t,s,2}(:,:,:);
            gx_final{t,s,2}(:,:,:) = gx_final{t,s,3}(:,:,:);
            gx_final{t,2,3}(:,:,:) = gx_final_2;
        end
    end

end

function validate_input(config)
    
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    if n_cols <= 10 || n_rows <= 10
       error('Bad stimulus dimensions: the toroidal boundary conditions are ill-defined.');
    end
end

function [gx_final, gy_final] = initialize_output(config)
%INITIALIZE_OUTPUT Initialize the output data structures
%   gx_final:   the excitation membrane potentials
%   gy_final:   the inhibition membrane potentials

    n_orients  = config.wave.n_orients;
    n_scales   = config.wave.n_scales;
    n_membr    = config.zli.n_membr;
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    
    gx_final = cell(n_orients, n_scales, n_membr);
    gy_final = cell(n_orients, n_scales, n_membr);
    for t=1:n_membr
        for s=1:n_scales
            for o=1:n_orients
                gx_final{o,s,t} = zeros(n_cols, n_rows, n_channels); 
                gy_final{o,s,t} = zeros(n_cols, n_rows, n_channels);
            end
        end
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

    n_orients  = config.wave.n_orients;
    n_scales   = config.wave.n_scales;
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    
    % x is initialized as the visual stimulus (p.192)
    t = 1; % use first time frame
    x = cell(n_scales, n_orients);
    for s=1:n_scales
        for o=1:n_orients
            x{o,s} = Iitheta{o,s,t};
        end
    end
    
    % y is initialized with zero activity
    y = cell(n_scales, n_orients);
    for s=1:n_scales
        for o=1:n_orients
            y{o,s} = zeros(n_cols, n_rows, n_channels);
        end
    end
end

function tIitheta = get_tIitheta(Iitheta, t, config)
    n_orients = config.wave.n_orients;
    n_scales  = config.wave.n_scales;
    tIitheta  = cell(n_orients, n_scales);
    % TODO we can just select like Iitheta(:,:,t)
    for s=1:n_scales
        for o=1:n_orients
            tIitheta{o,s} = Iitheta{o,s,t};
        end
    end
end
