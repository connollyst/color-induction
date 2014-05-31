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
    Delta     = zli.Delta*utils.scale2size(1:n_scales, zli.scale2size_type, zli.scale2size_epsilon);

    %% Initialize parameters
    params = struct;
    [M, N, K] = MNK(Iitheta);
    params.M         = M;
    params.N         = N;
    params.K         = K;
    % self-excitation coefficient (Li 1999)
    params.J0        = 0.8;
    params.prec      = 1/n_iter;
    params.var_noise = 0.1 * 2;
    % normalization (I_norm)
    params.r         = zli.normalization_power;
    % maximum diameter of the area of influence
    diameter = 2*Delta+1;
    % output membrane potentials
    [gx_final, gy_final] = initialize_output(params, n_membr, n_scales);

    %% Normalize input data
    Iitheta = model.normalize_input(Iitheta, config);
    
    %% Prepare normalization mask
    [M_norm_conv, inv_den] = model.Fer_M_norm_conv(n_scales, zli);

    %% Prepare orientation/scale interaction for x_ei
    [radius_sc, scale_filter, border_weight, PsiDtheta, Delta_ext] = ...
        model.terms.interaction_maps(Delta, config);

    %% Prepare J & W: the excitatory and inhibitory masks
    [all_J_fft, all_W_fft, M_norm_conv_fft, half_size_filter] = ...
        model.terms.JW(n_scales, diameter, radius_sc, K, Delta, M, N, M_norm_conv, config);

    %% Preallocate x & y: the excitation and inhibition activity
    % x is initialized as the visual stimulus (p.192)
    x = Iitheta{1};
    % y is initialized with zero activity
    y = zeros(M, N, n_scales, K);
    
    %% Run recurrent network: the loop over time
    for t_membr=1:n_membr  % membrane time
        fprintf('Membrane time step: %i/%i\n', t_membr, n_membr);
        tic
        for t_iter=1:n_iter  % from the differential equation (Euler!)
            fprintf('Membrane time step: %i\n', t_iter);
            [x, y] = model.process.updateXY(t_membr, Iitheta, x, y, M, N, K, PsiDtheta, Delta, Delta_ext, all_J_fft, all_W_fft, inv_den, M_norm_conv, M_norm_conv_fft, half_size_filter, n_scales, radius_sc, border_weight, scale_filter, params, config);
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
    M  = size(Iitheta{1}, 1);   % input width
    N  = size(Iitheta{1}, 2);   % input height
    if M <= 10 || N <= 10
       disp('Bad stimulus dimensions! The toroidal boundary conditions are ill-defined.')
    end
    % the number of neuron pairs in each hypercolumn (i.e. the number of preferred orientations)
    K  = size(Iitheta{1}, 4);
end

function [gx_final, gy_final] = initialize_output(params, n_membr, n_scales)
    % membrane potentials
    gx_final = cell(n_membr, 1);
    gy_final = cell(n_membr, 1);

    % preallocate
    for i=1:n_membr
        gx_final{i} = zeros(params.M, params.N, n_scales, params.K); 
        gy_final{i} = zeros(params.M, params.N, n_scales, params.K);
    end
end
