function config = get_default_parameters_NCZLd()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% wavelets' parameters %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% decomposition choice
wave.multires='DWD_orient_undecimated';

% number of orientations
wave.n_orients=3;

% number of scales (if 0: code calculates it automatically)
wave.n_scales=0; 
% wave.n_scales=5;
% wave.n_scales=4; 

% size of the last wavelet plane to process (Should be a power of 2 and >= 32)
% (see below zli.fin_scale_offset parameter in order to include or not residual plane)
wave.mida_min=32;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Z.Li's model parameters %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% differential equation. The total number of iterations is niter/prec
zli.n_membr=10;		% precision of membrane time
zli.n_iter=10;		% number of iterations; in the case of a dynamical stimulus, it is the number of frames
zli.J0= 0.8;        % self-excitation coefficient (Li 1999) p209
    
% zli.total_iter=zli.n_iter/zli.prec;
zli.dist_type='eucl';   % distance for I_norm
% zli.dist_type='manh';
% zli.scale2size_type=0;
zli.scale2size_type=-1;
zli.scale2size_epsilon=1.3; % 1 gives 2.^(s-1), 0.5 gives 1.^(s)
zli.reduccio_JW=1;  % reduce J and W
% zli.normal_type='scale';
zli.normal_type='all';
% zli.normal_type='absolute'; zli.normal_min_absolute=0; zli.normal_max_absolute=255;
zli.normal_min_absolute=0;
zli.normal_max_absolute=0.25;

% decay in the e/i recurrent equations
zli.alphax=1.0; % 1.6 !!!
zli.alphay=1.0; % 1.6 !!!
% multiplicative factor
zli.kappax=1.0; % 1.6 !!!
zli.kappay=1.35; % 1.6 !!!

% normalization
zli.normal_input=4;			% rescaled maximum value of input data for Z.Li method
zli.normal_output=2.0;		% rescaled maximum value of output data for Z.Li method
zli.Delta=15;				% maximum radius of the area of influence
zli.ON_OFF=0;	% 0: separate, 1: abs, 2:square
zli.boundary='mirror';  % or 'wrap'
zli.normalization_power=2; % power of the denominator in the normalization step
zli.kappax=1.0; % 1.6 !!!
zli.kappay=2.0; % 1.6 !!!
zli.shift=1;		% minimum value of input data for Z.Li method
zli.ini_scale=1;	% initial scale to process: scale=1 is the highest frequency plane
zli.fin_scale_offset=1;		% last plane to process will be n_scales - fin_scale (and its size will be wave.mida_min),
							% i.e. if =0 then residual will be processed (and its size will be wave.mida_min)
zli.scale_interaction_distance=1; % distance over which scales interact with each other

% Interaction configurations: yes/no
zli.scale_interaction   = 1;
zli.orient_interaction  = 1;
zli.channel_interaction = 0;
zli.add_neural_noise    = 0;
														  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% computational setting %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use MATLAB workers (0:no, 1:yes)
% compute.parallel=0;						% concurrent for every image
% compute.parallel_channel=0;			% concurrent for every channel (i.e. intensity and 2 chromatic)
% compute.parallel_scale=0;				% concurrent for every wavelet plane 
% compute.parallel_ON_OFF=0;				% concurrent for every wavelet plane 
% compute.parallel_orient=0;				% concurrent for every wavelet orientation 
compute.dynamic=0;						% 0 stable/1 dynamic stimulus
% compute.multiparameters=0;				% 0 for the first parameter of the list/ 1 for all the parameters
% use fft for speed
compute.use_fft=1;
% avoid circshift for speed
compute.avoid_circshift_fft=1;
% compute.output_type='image';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  stimulus (image, name...) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image.n_frames_promig=zli.n_membr-1;		% number iterations (from the last one) considered for the ouput (mean)
% image.updown=[1];							% up/downsample ([1,2])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% display plot/store    %%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display.logging=1;                  % display log messages
display.plot=1;                     % display plots
display.plot_io=1;					% plot input/output
display.reduce=0;					% 0 all (9)/ 1 reduced ; useless if single_or_multiple=1
display.plot_wavelet_planes=0;	    % plot wavelet planes
display.store=1;					% 0 don't store/ 1 store
display.y_video=0.5;
display.x_video=68/128;


config = struct('zli',zli,'wave',wave,'image',image,'display',display,'compute',compute);


end