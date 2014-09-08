function I_out = transform( I_in, config )
%MODEL.DATA.COLOR.TRANSFORM
%   Transform the input image to the specified colorspace.
%
%   Input
%       I_in:   the input image, in RGB colorspace
%       config: the model configuration
%   Output
%       I_out:  the output image, in the requested colorspace

    I_out = cell(size(I_in));
    transform = config.image.transform;
    switch transform
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
        case 'rgb2itti'
            % Transform from RGB to RGBY..
            logger.log('Converting RGB image to LDRGBY (L. Itti, 1998)..', config);
            for i=1:length(I_in)
                I_out{i} = model.data.color.rgb2itti(I_in{i});
            end
        otherwise
            error('Unsupported image pre-transform: %s', transform)
    end
end