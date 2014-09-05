function [wavelets_out, residuals_out] = posttransform(wavelets_in, residuals_in, config)
%MODEL.DATA.COLOR.POSTTRANSFORM
%   Transform the input image to the specified colorspace.
%   This transformation occurs after the image decomposition step. For
%   color transformations prior to decomposition, refer to:
%     model.data.color.pretransform
%
%   Input
%       wavelets_in:   the decomposed image wavelets
%       residuals_in:  the decomposed image residuals
%       config:        the model configuration
%   Output
%       wavelets_out:  the output wavelets, in the requested colorspace
%       residuals_out: the output residuals, in the requested colorspace
    switch config.image.transform.post
        case 'none'
            % Do not perform any post decompisition color transformation
            wavelets_out  = wavelets_in;
            residuals_out = residuals_in;
        case 'rgb2rgby'
            % Transform from RGB to RGBY..
            logger.log('Converting RGB image to RGBY (L. Itti, 1998)..', config);
            wavelets_out  = cell(size(wavelets_in));
            residuals_out = cell(size(residuals_in));
            for i=1:length(wavelets_in)
                wavelets_out{i}  = model.data.color.rgb2rgby(wavelets_in{i});
                % TODO model.data.color.rgb2rgby(wavelets_in{i}, wavelets_in{i+1});
                residuals_out{i} = model.data.color.rgb2rgby(residuals_in{i});
                % TODO are the residuals still valid for image recovery?
            end
        otherwise
            error('Unsupported image pre-transform: %s',config.image.transform.pre)
    end
end