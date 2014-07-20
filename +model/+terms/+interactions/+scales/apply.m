function interaction = apply(data, scale_interactions, config)
% Apply scale filter to get interactions between scales.
    if ~config.zli.interaction.scale.enabled
        interaction  = data;
    else
        scale_filter = scale_interactions.filter;
        interaction  = model.data.convolutions.optima(data, scale_filter, 0, 0);
    end
end