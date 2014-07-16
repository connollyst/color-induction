function img_out = process_image(img, img_type, n_membr, varargin)
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
% img: the input image(s)
%   If it is a still image (static version), it has to be a two or three dimensional array.
% 	If it is a temporal sequence of images with 'n_frames' frames (dynamical version),
%   it has to be cell structure of two or three dimensional images with size {n_frames}(:,:,:).
% 
% img_type: the type of input images: 'bw', 'rgb'
% 
% n_membr: number of membrane time constant considered in the computation (recommended to be > 15)
% 
% Note that internal parameters of the method can be modified in the get_default_parameters_NCZLd() routine
% or below.
    
    if length(varargin) == 1
        % parameters for the differential equation (Euler integration scheme)
        config_function_name = varargin{1};
        config_function      = str2func(['configurations.',config_function_name]);
        config               = config_function();
    else
        config = configurations.double_opponent();
    end

    if config.wave.n_scales == 0
        % calculate number of scales automatically
        config.wave.n_scales = model.utils.calculate_n_scales(I, config);    
    end
    
    config.image.type = img_type;
    config.zli.n_membr = n_membr;	% number of membrane time constant

    img_out = model.apply(img, config);
end