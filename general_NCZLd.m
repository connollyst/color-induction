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
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%% Z.Li's model parameters %%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters for the differential equation (Euler integration scheme)
zli.n_membr=n_membr;  % number of membrane time constant

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%% computational setting %%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
   
