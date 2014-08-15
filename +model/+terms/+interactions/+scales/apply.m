function interaction = apply(data, scale_interactions, config)
% Apply scale filter to get interactions between scales.
    if ~config.zli.interaction.scale.enabled
        interaction = data;
    else
        filter = scale_interactions.filter;
        interaction = model.data.convolutions.optimal(data, filter);
    end
end