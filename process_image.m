function img_out = process_image(img_data, img_type, varargin)
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
% img_data: the input image(s)
%   If it is a still image (static version), it has to be a two or three dimensional array.
% 	If it is a temporal sequence of images with 'n_frames' frames (dynamical version),
%   it has to be cell structure of two or three dimensional images with size {n_frames}(:,:,:).
% 
% img_type: the type of input images: 'bw', 'rgb'
% n_membr: number of membrane time constant considered in the computation (recommended to be > 15)
% 
% Note that internal parameters of the method can be modified in the get_default_parameters_NCZLd() routine
% or below.
    
    cfg = configurations.get_defaults();

    cfg.image.type    = img_type;           % TODO validate
    cfg.image.dynamic = iscell(img_data);   % Is the image_data dynamic or static?

    if length(varargin) == 1
        % parameters for the differential equation (Euler integration scheme)
        n_membr                   = varargin{1};
        cfg.zli.n_membr           = n_membr;	% number of membrane time constant    
        cfg.image.n_frames_promig = n_membr-1;	% The number of iterations (starting from the end) used
                                                % to compute the output of the model (by taking the mean)
    end

    img_out = model.process(img_data, cfg);
end