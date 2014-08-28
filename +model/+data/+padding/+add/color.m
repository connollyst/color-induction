function I_padded = color(I, color_interactions, config)
%PADDING.ADD.COLOR Add padding to the color channel.
    if ~config.zli.interaction.color.enabled
        I_padded = I;
    else
        if model.data.utils.is_odd(config.image.n_channels)
            error('MODEL:uneven_opponent', ['Opponent color ' ...
               'interactions require an even number of color channels.'])
        end
        color_model = config.zli.interaction.color.model;
        switch color_model
            case 'default'
                n_interactions = color_interactions.n_interactions;
                n_channels     = config.image.n_channels;
                padding        = (n_interactions - n_channels) / 2;
                I_padded       = padarray(I, [0 0 padding 0 0], 'circular');
            otherwise
                error('MODEL:UnsupportedPadding', ...
                      ['Color padding not supported for ''',color_model,'''']);
        end
    end
end

