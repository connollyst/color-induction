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
            n_cols     = config.image.width;
            n_rows     = config.image.height;
            n_channels = 4; % RGBY
            n_scales   = config.wave.n_scales;
            n_orients  = config.wave.n_orients;
            for i=1:length(wavelets_in)
                w_in  = wavelets_in{i};
                r_in  = residuals_in{i};
                w_out = zeros(n_cols, n_rows, n_channels, n_scales-1, n_orients);
                r_out = zeros(n_cols, n_rows, n_channels, n_scales-1);
                for s=1:n_scales-1
                    for o=1:config.wave.n_orients
                        w_in_center      = w_in(:,:,:,s,o);
                        w_in_surround    = w_in(:,:,:,s+1,o);
                        w_out(:,:,:,s,o) = model.data.color.rgb2rgby(w_in_center, w_in_surround);
                    end
                    r_in_center      = r_in(:,:,:,s);
                    r_in_surround    = r_in(:,:,:,s+1);
                    r_out(:,:,:,s) = model.data.color.rgb2rgby(r_in_center, r_in_surround);
                end
                wavelets_out{i}  = w_out;
                residuals_out{i} = r_out;
                % TODO are the residuals still valid for image recovery?
            end
        otherwise
            error('Unsupported image pre-transform: %s',config.image.transform.pre)
    end
end