function [gx_final] = Rmodelinductiond_v0_3_2(Iitheta, config)
%RMODELINDUCTIOND_V0_3_2 Apply induction model to input data.
%   From NCZLd_channel_ON_OFF_v1_1.m to all the functions for implementing
%   Li 1999.
%   Iitheta: Cell struct of input stimuli at each membrane time step, eg:
%            Iitheta{t,s,o}(c,r,d) is the column (c), row (r) and color
%            dimension (d) of image (t), decomposed at scale (s) and
%            orientation (o).
%   config:  The model configuration struct
%
%   gx_final:   the excitation membrane potentials

    %% get the structure and the parameters
    wave      = config.wave;
    zli       = config.zli;
    n_scales  = wave.n_scales;
    n_membr   = zli.n_membr;
    n_iter    = zli.n_iter;
    Delta     = zli.Delta * utils.scale2size(1:n_scales, zli.scale2size_type, zli.scale2size_epsilon);

    %% Initialize parameters
    [M, N, K]            = MNK(Iitheta);
    % output membrane potentials
    [gx_final, gy_final] = initialize_output(M, N, K, n_membr, n_scales);

    %% Normalize input data
    Iitheta = model.normalize_input(Iitheta, config);
    
    %% Prepare normalization mask
    normalization_masks = model.terms.get_normalization_masks(M, N, config);

    %% Prepare orientation/scale interactions for x_ei
    interactions = model.terms.get_interactions(Delta, config);
    
    %% Prepare J & W: the excitatory and inhibitory masks
    JW = model.terms.get_JW(M, N, K, Delta, interactions.radius_sc, config);

    %% Preallocate x & y: the excitation and inhibition activity
    x = Iitheta{1};                 % initialized as the visual stimulus (p.192)
    y = zeros(M, N, n_scales, K);   % initialized with zero activity
    
    %% Run recurrent network: the loop over time
    for t_membr=1:n_membr  % membrane time
        fprintf('Membrane time step: %i/%i\n', t_membr, n_membr);
        tic
        for t_iter=1:n_iter  % from the differential equation (Euler!)
            fprintf('Membrane interation: %i/%i\n', t_iter, n_iter);
            [x, y] = model.process.UpdateXY(...
                        t_membr, Iitheta, x, y, M, N, K, Delta, JW,...
                        normalization_masks, interactions, config...
                     );
        end
        toc
        gx_final{t_membr} = model.terms.newgx(x);
        gy_final{t_membr} = model.terms.newgy(y);
    end

    for i=1:n_membr
        gx_final_2=gx_final{i}(:,:,:,2);
        gx_final{i}(:,:,:,2)=gx_final{i}(:,:,:,3);
        gx_final{i}(:,:,:,3)=gx_final_2;
    end

end

function [M, N, K] = MNK(Iitheta)
%MNK Extract M, N, & K properties of the input data
%   Iitheta:    the input data
%   
%   M:          the input data width (cols)
%   N:          the input data height (rows)
%   K:          the number of neuron pairs in each hypercolumn
%                   (i.e. the number of preferred orientations)
    M = size(Iitheta{1}, 1);
    N = size(Iitheta{1}, 2);
    K = size(Iitheta{1}, 4);
    if M <= 10 || N <= 10
       disp('Bad stimulus dimensions! The toroidal boundary conditions are ill-defined.')
    end
end

function [gx_final, gy_final] = initialize_output(M, N, K, n_membr, n_scales)
%INITIALIZE_OUTPUT Initialize the output data structures
%   M:          the input data width
%   N:          the input data height
%   K:          the number of preferred orientations
%   n_membr:    the number of membrane time steps being processed
%   n_scales:   the number of scale sizes being processed
%
%   gx_final:   the excitation membrane potentials
%   gy_final:   the inhibition membrane potentials

    gx_final = cell(n_membr, 1);
    gy_final = cell(n_membr, 1);
    for i=1:n_membr
        gx_final{i} = zeros(M, N, n_scales, K); 
        gy_final{i} = zeros(M, N, n_scales, K);
    end
end
