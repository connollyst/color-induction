function I_padded = color(I, color_interactions, config)
%PADDING.ADD.COLOR Add padding to the color channel.
    if ~config.zli.interaction.color.enabled
        I_padded = I;
    else
        % TODO padding dimensions need to be provided
        I_padded = padarray(I, [0 0 2], 'circular');
    end
end

