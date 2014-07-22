function x_padded = add(x, interactions, config)
%PADDING.ADD Add padding to prevent edge effects.
    x_padded = model.data.padding.add.color(x, config);
    x_padded = model.data.padding.add.scale(x_padded, interactions.scale, config);
end