function I = color(I_padded, color_interactions, config)
%PADDING.REMOVE.COLOR Remove padding from the color channel.
    if ~config.zli.interaction.color.enabled
        I = I_padded;
    else
        n_interactions = color_interactions.n_interactions;
        n_channels     = config.image.n_channels;
        n_padding      = (n_interactions - n_channels) / 2;
        center         = n_padding+1:n_padding+n_channels;
        I              = I_padded(:,:,center,:,:);
    end
end