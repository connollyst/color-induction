function LDRGBY = transform(varargin)
%MODEL.DATA.RF.TRANSFORM Process the RGB image into opponent colors.
%
%   Input
%       rgb_center:   the rgb image of center signal
%       rgb_surround: the rgb image of surround signal
%                     (optional - defaults to rgb_center)
%       config:       the model configuration
%   Output
%       LDRGBY: the opponent color components

    % Interpret function arguments..
    switch length(varargin)
        case 2
            rgb_center   = im2double(varargin{1});
            rgb_surround = im2double(varargin{1});
            config       = varargin{2};
        case 3
            rgb_center   = im2double(varargin{1});
            rgb_surround = im2double(varargin{2});
            config       = varargin{3};
        otherwise
            error('Expected 1 or 2 parameters, got %i', length(varargin));
    end
    
    % Transform using the appropriate opponent color function..
    switch config.rf.method
        case 'rgb2opp'
            LDRGBY = model.data.color.rgb2opp(rgb_center, rgb_surround);
        case 'rgb2itti'
            LDRGBY = model.data.color.rgb2itti(rgb_center, rgb_surround);
        otherwise
            error('Unknown config.rf.method: %s', config.rf.method);
    end
end

