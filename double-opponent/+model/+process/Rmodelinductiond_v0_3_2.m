function [gx_final] = Rmodelinductiond_v0_3_2(Iitheta, config)
%Rmodelinductiond_v0_3_2 apply model to input image
%   from NCZLd_channel_ON_OFF_v1_1.m to all the functions for implementing
%   Li 1999
%   Iitheta: cell struct of input stimuli at each membrane time step, eg:
%            Iitheta{1}(:,:,2,3) is the full image decomposed at the
%            second scale and third orientation.
%   config:  the model configuration struct

    %% get the structure and the parameters
    wave      = config.wave;
    n_scales  = wave.n_scales;
    zli       = config.zli;
    % config.zli
    n_membr   = zli.n_membr;
    n_iter    = zli.n_iter;
    % TODO the bowtie should not be scaled, right?
    Delta     = zli.Delta * utils.scale2size(1:n_scales, zli.scale2size_type, zli.scale2size_epsilon);

    %% Initialize parameters
    [M, N, K]            = MNK(Iitheta);
    % maximum diameter of the area of influence
    diameter             = 2*Delta+1;
    % output membrane potentials
    [gx_final, gy_final] = initialize_output(M, N, K, n_membr, n_scales);

    %% Normalize input data
    Iitheta = model.normalize_input(Iitheta, config);
    
    %% Prepare normalization mask
    [M_norm_conv, inv_den] = model.make_M_norm_conv(config);

    %% Prepare orientation/scale interactions for x_ei
    interactions = model.terms.interaction_maps(Delta, config);

    %% Prepare J & W: the excitatory and inhibitory masks
    [all_J_fft, all_W_fft, M_norm_conv_fft, half_size_filter] = ...
        model.terms.JW(M, N, K, diameter, Delta, M_norm_conv, interactions.radius_sc, config);

    %% Preallocate x & y: the excitation and inhibition activity
    x = Iitheta{1};                 % initialized as the visual stimulus (p.192)
    y = zeros(M, N, n_scales, K);   % initialized with zero activity
    
    %% Run recurrent network: the loop over time
    for t_membr=1:n_membr  % membrane time
        fprintf('Membrane time step: %i/%i\n', t_membr, n_membr);
        tic
        for t_iter=1:n_iter  % from the differential equation (Euler!)
            fprintf('Membrane interation: %i/%i\n', t_iter, n_iter);
            [x, y] = model.process.updateXY(t_membr, Iitheta, x, y, M, N, K, Delta, all_J_fft, all_W_fft, inv_den, M_norm_conv, M_norm_conv_fft, half_size_filter, interactions, config);
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
    M = size(Iitheta{1}, 1);   % input width
    N = size(Iitheta{1}, 2);   % input height
    if M <= 10 || N <= 10
       disp('Bad stimulus dimensions! The toroidal boundary conditions are ill-defined.')
    end
    % the number of neuron pairs in each hypercolumn (i.e. the number of preferred orientations)
    K = size(Iitheta{1}, 4);
end

function [gx_final, gy_final] = initialize_output(M, N, K, n_membr, n_scales)
    % membrane potentials
    gx_final = cell(n_membr, 1);
    gy_final = cell(n_membr, 1);
    % preallocate
    for i=1:n_membr
        gx_final{i} = zeros(M, N, n_scales, K); 
        gy_final{i} = zeros(M, N, n_scales, K);
    end
end
