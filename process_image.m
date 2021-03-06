function [img_out, out] = process_image(img, n_membr, varargin)
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
% img_transform: the type of transform to apply to the images: 'none', 'lab', 'zhang'
% 
% n_membr: number of membrane time constant considered in the computation (recommended to be > 15)
% 
% Note that internal parameters of the method can be modified in
% configurations.default, or in your own configuration.
    
    switch length(varargin)
        case 0
            config = configurations.default;
        case 1
            config = load_config(varargin{1});
        otherwise
            error('Invalid use: only one variable argument supported.');
    end
    
    if config.wave.n_scales == 0
        % calculate number of scales automatically
        config.wave.n_scales = model.utils.calculate_n_scales(img, config);    
    end
    
    config.zli.n_membr = n_membr;	% number of membrane time constant

    [img_out, out] = model.apply(img, config);
end

function config = load_config(config_function_name)
    config_function      = str2func(['configurations.',config_function_name]);
    config               = config_function();
end