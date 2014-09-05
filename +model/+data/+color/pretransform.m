function I_out = pretransform( I_in, config )
%MODEL.DATA.COLOR.PRETRANSFORM
%   Transform the input image to the specified colorspace.
%
%   Input
%       I_in:   the input image, in RGB colorspace
%       config: the model configuration
%   Output
%       I_out:  the output image, in the requested colorspace

    I_out = cell(size(I_in));
    
    switch config.image.transform
        case 'none'
            % Use the image in the provided colorspace..
            for i=1:length(I_in)
                I_out{i} = im2double(I_in{i});
            end
        case 'rgb2lab'
            % Transform from RGB to L*a*b..
            logger.log('Converting RGB image to CIE L*a*b..', config);
            for i=1:length(I_in)
                I_out{i} = model.data.color.rgb2lab(I_in{i});
            end
        case 'rgb2rgby'
            % Transform from RGB to RGBY..
            logger.log('Converting RGB image to RGBY (L. Itti, 1998)..', config);
            for i=1:length(I_in)
                I_out{i} = model.data.color.rgb2rgby(I_in{i});
            end
        case 'itti' %DEPRECATED
            % Transform from RGB to L. Itti's RGBY..
            logger.log('Converting RGB image to RGBY (L. Itti, 1998)..', config);
            for i=1:length(I_in)
                [~, R, G, B, Y] = model.data.color.itti.IRGBY(I_in{i});
                RGBY = zeros(size(R, 1), size(R, 2), 4);
                RGBY(:,:,1) = R;
                RGBY(:,:,2) = G;
                RGBY(:,:,3) = B;
                RGBY(:,:,4) = Y;
                I_out{i} = RGBY;
            end
        otherwise
            error('Unsupported image transform: %s',config.image.transform)
    end
end