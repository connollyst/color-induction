function img_out = process_image(image_data, varargin)
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
% Note that internal parameters of the method can be modified in the get_default_parameters_NCZLd() routine
% or below.
    
    cfg = configurations.get_defaults();

    % Is the image_data dynamic or static?
    cfg.compute.dynamic = iscell(image_data);

    if length(varargin) == 1
        % parameters for the differential equation (Euler integration scheme)
        n_membr                   = varargin{1};
        cfg.zli.n_membr           = n_membr;	% number of membrane time constant    
        cfg.image.n_frames_promig = n_membr-1;	% The number of iterations (starting from the end) used
                                                % to compute the output of the model (by taking the mean)
    end

    cfg.display.plot_io             = 0;  % plot input/output
    cfg.display.reduce              = 0;  % 0 all (9)/ 1 reduced (useless if single_or_multiple=1)
    cfg.display.plot_wavelet_planes = 0;  % display wavelet coefficients
    cfg.display.store               = 0;  % 0 don't store/ 1 store curv, iFactor and more...
    cfg.display.store_img_img_out   = 0;  % 0/1 don't save/save img and img_out

    img_out = model.do_process(image_data, cfg);
end