function color_filter = inhibition_filter(config)
%MODEL.TERMS.INTERACTIONS.COLORS.INHIBITION_FILTER 
%   Returns the inhibitory color interaction filter appropriate for the
%   given config.
    if ~config.zli.interaction.color.enabled
        color_filter = model.terms.interactions.filter_nothing();
    else
        switch config.zli.interaction.color.scheme
            case 'default'
                % DEFAULT COLOR INHIBITION FILTER:
                % By default, colors don't inhibit each other.
                color_filter = model.terms.interactions.filter_nothing();
            case 'opponent'
                if ~model.data.utils.is_even(config.image.n_channels)
                    error('MODEL:config', ['Opponent color interactions ', ...
                        'require an even number of color channels.'])
                end
                % OPPONENT COLOR EXCITATION FILTER:
                % Opponent colors come in pairs. Pairs do not inhibit each
                % other, but paired colors do.
                filter_size   = 2;     % pair=2 (becomes 3 as a symmetric filter)
                filter_weight = config.zli.interaction.color.weight.inhibition;
                color_filter  = model.terms.interactions.filter_equally( ...
                                    filter_size, filter_weight ...
                               );
            otherwise
                error('Invalid: config.zli.interaction.color.scheme=%s',...
                                config.zli.interaction.color.scheme)
        end
    end
end