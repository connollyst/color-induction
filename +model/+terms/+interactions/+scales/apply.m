function interaction = apply(data, scale_interactions, config)
% Apply scale filter to get interactions between scales.
    if ~config.zli.interaction.scale.enabled
        interaction = data;
    else
        interaction = model.data.convolutions.optima( ...
                            data, scale_interactions.filter, 0, 0 ...
                      );
    end
end