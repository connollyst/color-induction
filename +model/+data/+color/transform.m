function I_out = transform( I_in, config )
%MODEL.DATA.COLOR.TRANSFORM
%   Transform the input image to the appropriate color space.
    
    I_out = cell(size(I_in));
    
    switch config.image.transform
        case 'none'
            % Trust that the input data is already in an appropriate space..
            logger.log('WARNING: not applying color transformation..', config);
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
        otherwise
            error('Unsupported image transform: %s',config.image.transform)
    end
end