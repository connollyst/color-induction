function color_filter = filter(config)
%MODEL.TERMS.INTERACTIONS.COLORS.FILTER 
%   Returns the color interaction filter appropriate for the given config.
    if ~config.zli.channel_interaction
        color_filter = 1;
    else
        switch config.zli.ON_OFF
            case 'separate'
                color_filter = ones(1,config.image.n_channels);
            case 'opponent'
                color_filter = ones(1,2);
            otherwise
                error('Invalid: config.zli.ON_OFF=%s', config.zli.ON_OFF)
        end
    end
end