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
    
    switch config.image.transform
        case 'rgb'
            % Trust that the input data is already in an appropriate space..
            for i=1:length(I_in)
                I_out{i} = im2double(I_in{i});
            end
        case 'lab'
            % Transform from RGB to L*a*b
            logger.log('Converting RGB image to L*a*b..', config);
            cform = makecform('srgb2lab');
            for i=1:length(I_in)
                I_out{i} = lab2double(applycform(I_in{i}, cform));
            end
        case 'itti'
            % Transform from RGB to L. Itti's IRGBY
            logger.log('Converting RGB image to IRGBY (L. Itti, 1998)..', config);
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