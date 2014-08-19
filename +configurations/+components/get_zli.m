function zli = get_zli()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Z.Li's model parameters %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % differential equation. The total number of iterations is niter/prec
    zli.n_membr                    = 10;            % precision of membrane time
    zli.n_iter                     = 10;            % number of iterations; in the case of a dynamical stimulus, it is the number of frames
    zli.J0                         = 0.8;           % self-excitation coefficient (Li 1999) p209
    zli.dist_type                  ='eucl';         % distance for I_norm
    zli.scale2size_type            = -1;
    zli.scale2size_epsilon         = 1.3;           % 1 gives 2.^(s-1), 0.5 gives 1.^(s)
    zli.reduccio_JW                = 1;             % reduce J and W
    zli.normal_type                = 'all';         % all/scale/absolute
    zli.normal_min_absolute        = 0;
    zli.normal_max_absolute        = 0.25;          % of 255?

    % decay in the e/i recurrent equations
    zli.alphax                     = 1.0;           % 1.6 !!!
    zli.alphay                     = 1.0;           % 1.6 !!!
    % multiplicative factor
    zli.kappax                     = 1.0;           % 1.6 !!!
    zli.kappay                     = 1.35;          % 1.6 !!!

    % normalization
    zli.normal_input               = 4;             % rescaled maximum value of input data for Z.Li method
    zli.normal_output              = 2.0;           % rescaled maximum value of output data for Z.Li method
    zli.Delta                      = 15;            % maximum radius of the area of influence
    zli.ON_OFF                     = 'on';          % 'abs', 'square', or 'separate'
    zli.boundary                   = 'mirror';      % 'mirror' or 'wrap'
    zli.normalization_power        = 2;             % power of the denominator in the normalization step
    zli.shift                      = 1;             % minimum value of input data for Z.Li method
    zli.ini_scale                  = 1;             % initial scale to process: scale=1 is the highest frequency plane
    zli.scale_interaction_distance = 1;             % distance over which scales interact with each other
    zli.fin_scale_offset           = 1;             % last plane to process will be n_scales - fin_scale (and its size will be wave.mida_min),
                                                    % i.e. if =0 then residual will be processed (and its size will be wave.mida_min)
    zli.add_neural_noise           = false;
    
    % Interaction configurations: true/false
    zli.interaction.orient.enabled = true;
    zli.interaction.scale.enabled  = true;
    zli.interaction.color.enabled  = true;
    
    % Opponet color interactions weights
    zli.interaction.color.weight.excitation = 0.01;  % TODO determine appropriate value
    zli.interaction.color.weight.inhibition = 0.01;  % TODO determine appropriate value
end