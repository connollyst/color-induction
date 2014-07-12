function img_out = general_NCZLd(image_data, n_membr, dynamic)
% This code implements the computational model described in the paper
% 
% "A neurodynamical model of brightness induction in V1"
% O. Penacchio, X. Otazu and L. Dempere-Marco
% PLOS ONE, 2013
%
% For more information: penacchio@cvc.uab.cat,xotazu@cvc.uab.cat 
% 
% ---------------------------------------------------------------
% Parameters:
% 
% image_data: That it the input image
%   If it is a still image (static version), it has to be a two or three dimensional array.
% 	If it is a temporal sequence of images with 'n_frames' frames (dynamical version),
%   it has to be cell structure of two or three dimensional images with size {n_frames}(:,:,:).
% 
% n_membr: number of membrane time constant considered in the computation (recommended to be > 15)
%
% dynamic: 0 (static setting)/1 (dynamical setting) 
% 
% Note that internal parameters of the method can be modified in the get_default_parameters_NCZLd() routine
% or below.

%--------------------------------------------------------------------
% build the structure
clear cfg wave zli display_plot compute 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Default parameters %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg = config.get_default_parameters_NCZLd();

% Prepare structures 
zli     = cfg.zli;
wave    = cfg.wave;
image   = cfg.image;
display = cfg.display;
compute = cfg.compute;

image.n_frames_promig = zli.n_membr-1;    % The number of iterations (starting from the end) used
                                          % to compute the output of the model (by taking the mean)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% The following parameters overwrite the previous ones %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters for the last experiments

    % min frequency processed (size of the last wavelet plane. Should be a power of 2 and >= 32)
    wave.mida_min=32;
    zli.scale2size_type=-1;
	% epsilon=1 gives 2.^(s-1)
    % epsilon=0.5 gives 1.^(s)
    zli.scale2size_epsilon=1.3;
    % kappa y
    zli.kappay=1.35;
    % rescaled maximum value of output data for Z.Li method
    zli.normal_output=2;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%% parameters for wavelets %%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% choice for a wavelet decomposition
wave.multires='a_trous';
zli.normal_min_absolute=0;
zli.normal_max_absolute=0.25;
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%% Z.Li's model parameters %%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters for the differential equation (Euler integration scheme)
zli.n_membr=n_membr;  % number of membrane time constant
zli.n_iter=10;   % integration steps in the Euler integration scheme

% distance for I_norm
zli.dist_type='eucl';
% zli.dist_type='manh';

% type of normalization
% zli.normal_type='scale';
zli.normal_type='all';
% zli.normal_type='absolute';

% reduce J and W
zli.reduccio_JW=1;

% decay in the e/i recurrent equations
zli.alphax=1.0;
zli.alphay=1.0;

% multiplicative factor
zli.kappax=1.0; %  !!!

% power of the denominator in the normalization step 
zli.normalization_power=2; 

% scale interaction yes/no
zli.scale_interaction=1;

% orientation interaction yes/no
zli.orient_interaction=1;

% 0: ON and OFF are separated; 1: absolute value; 2: quadratic
zli.ON_OFF=0;								
% minimum value of input data for Li's method
zli.shift=1;	

% rescaled maximum value of input data for Z.Li method
zli.normal_input=4;						

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%% computational setting %%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% use fft for speed
compute.use_fft=1;
% avoid circshift for speed
compute.avoid_circshift_fft=1;
% debug (display control values)
compute.XOP_DEBUG=0;
% debug (display scale interaction information)
compute.scale_interaction_debug=0;
% dynamic
compute.dynamic=dynamic;
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%  stimulus (image, name...) %%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

image.tmp=image_data;
image.n_frames_promig=n_membr-1;	% The number of iterations (starting from the end) used
                                        % to compute the output of the model (by taking the mean)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% display plot/store  %%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

display.plot_io=0;  % plot input/output
display.reduce=0;   % 0 all (9)/ 1 reduced (useless if single_or_multiple=1)
display.plot_wavelet_planes=0;  % display wavelet coefficients
display.store=0;    % 0 don't store/ 1 store curv, iFactor and more...
display.store_img_img_out=0;   % 0/1 don't save/save img and img_out

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%    meta structure     %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

strct=struct('zli',zli,'wave',wave,'image',image,'display',display,'compute',compute);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   core of the process -> NCZLd   %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img_out = model.process.NCZLd(image_data,strct);
	
end
   
