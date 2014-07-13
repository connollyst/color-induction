function img_out = process_image(img_data, img_type, n_membr, varargin)
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
    
    if length(varargin) == 1
        % parameters for the differential equation (Euler integration scheme)
        cfg_function_name = varargin{1};
        cfg_function      = str2func(['configurations.',cfg_function_name]);
        cfg               = cfg_function();
    else
        cfg = configurations.double_opponent();
    end

    cfg.image.type = img_type;
    cfg.zli.n_membr = n_membr;	% number of membrane time constant

    img_out = model.apply(img_data, cfg);
end