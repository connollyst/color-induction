function excitation = apply_excitation(data, color_interactions, config)
% Apply color filter to get interactions between color channels.
    if ~config.zli.interaction.color.enabled
        excitation = data;
    else
        color_filter = color_interactions.excitation_filter;
        switch config.zli.interaction.color.scheme
            case 'default'
                % Activity in any color channel excites all others
                % TODO should be combinatorial pair-wise
                excitation = model.data.convolutions.optima(data, color_filter, 0, 0);
            case 'opponent'
                % Activity in any color channel excites all others
                % TODO should be combinatorial pair-wise
                excitation = model.data.convolutions.optima(data, color_filter, 0, 0);
            otherwise
                error('Invalid: config.zli.interaction.color.scheme=%s',...
                                config.zli.interaction.color.scheme)
        end
    end
end