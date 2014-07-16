function I_out = transform( I_in, config )
%INIT_INPUT Initialize the input image(s)
%   If it is a single image, return a 1x1 cell containg just that image.
%   If it is a cell array of images, return the cell array.
    if ~iscell(I_in)
        I_in = double(I_in);
        I_out = cell(1, 1);
        I_out{1} = I_in;
    else
        % TODO validate input images: same dimensions
        I_out = I_in;
    end
    
    % Transform the original image data to the color space for processing
    switch config.image.type
        case 'bw'
            % Just process intensity..
            for i=1:length(I_out)
                I_out{i} = im2double(I_out{i});
            end
        case 'rgb'
            % Transform from RGB to L*a*b
            cform = makecform('srgb2lab');
            for i=1:length(I_out)
                I_out{i} = lab2double(applycform(I_out{i}, cform));
            end
        case 'lab'
            % Trust that the input data is already in L*a*b..
        otherwise
            error('Invalid input image type: %s', config.image.type)
    end
end