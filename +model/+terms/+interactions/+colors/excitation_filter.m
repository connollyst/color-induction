function color_filter = excitation_filter(config)
%MODEL.TERMS.INTERACTIONS.COLORS.EXCITATION_FILTER 
%   Returns the excitatory color interaction filter appropriate for the
%   given config.
    if ~config.zli.interaction.color.enabled
        color_filter = model.terms.interactions.filter_nothing();
    else
        if ~model.data.utils.is_even(config.image.n_channels)
            error('MODEL:uneven_opponent', ['Opponent color ' ...
                'interactions require an even number of color channels.'])
        end
        color_model  = config.zli.interaction.color.model;
        switch color_model
            case 'default'
                % A color channel excites all others
                filter_size = config.image.n_channels;
            case 'opponent'
                if config.image.n_channels == 2
                    error('MODEL:InsufficientChannels', ...
                          ['Opponent color interaction model not supported ',        ...
                           'with only 2 opponent color channels.\n',                 ...
                           'Set config.zli.interaction.color.model to ''default'' ', ...
                           'or config.zli.interaction.color.enabled to ''false''.']);
                end
                % A color channel excites all except it's opponent
                filter_size = config.image.n_channels - 1;
            otherwise
                error('MODEL:BadConfig', ...
                      'Unrecognized color interaction model: %s', color_model);
        end
        opponent_weight = config.zli.interaction.color.weight.excitation;
        color_filter    = model.terms.interactions.filter_equally(...
                                filter_size, opponent_weight ...
                          );
    end
end