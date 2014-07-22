function n = n_interactions(config)
%MODEL.TERMS.INTERACTIONS.COLORS.N_INTERACTIONS
%   The number of color interactions
    if config.zli.interaction.color.enabled
        n = config.image.n_channels * 2;
    else
        n = config.image.n_channels;
    end
end

