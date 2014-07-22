function color_filter = inhibition_filter(config)
%MODEL.TERMS.INTERACTIONS.COLORS.INHIBITION_FILTER 
%   Returns the inhibitory color interaction filter appropriate for the
%   given config.
    if ~config.zli.interaction.color.enabled
        color_filter = model.terms.interactions.filter_nothing();
    else
        if ~model.data.utils.is_even(config.image.n_channels)
            error('MODEL:config', ['Opponent color interactions ', ...
                'require an even number of color channels.'])
        end
        % Opponent colors come in pairs. Each color only inhibits
        % it's paired color.
        filter_size   = 2;     % pair=2 (becomes 3 as a symmetric filter)
        filter_weight = config.zli.interaction.color.weight.inhibition;
        color_filter  = model.terms.interactions.filter_equally( ...
                            filter_size, filter_weight ...
                       );
    end
end