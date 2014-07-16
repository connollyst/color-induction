function I_out = transform( I_in, config )
%INIT_INPUT Transform the input image to the appropriate color space.
    
    % TODO do we want to limit to RGB??
    %if ~model.data.utils.is_rgb(I_in)
    %    error('Expected RGB image as input.');
    %end
    
    I_out = I_in;
    
    % Transform the original image data to the color space for processing
    switch config.image.type
        case 'bw'
            % Just process intensity..
            logger.log('Processing B&W image..', config);
            for i=1:length(I_out)
                I_out{i} = im2double(I_out{i});
            end
        case 'rgb'
            % Transform from RGB to L*a*b
            logger.log('Converting RGB image to L*a*b..', config);
            cform = makecform('srgb2lab');
            for i=1:length(I_out)
                I_out{i} = lab2double(applycform(I_out{i}, cform));
            end
        case 'lab'
            % Trust that the input data is already in L*a*b..
            logger.log('Processing L*a*b image..', config);
        otherwise
            error('Invalid input image type: %s', config.image.type)
    end
end