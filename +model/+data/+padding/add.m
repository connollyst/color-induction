function [x_padded, y_padded] = add(x, y, interactions, config)
%PADDING.ADD Add padding to prevent edge effects.
    x_padded = model.data.padding.add.color(x,        interactions.color, config);
    y_padded = model.data.padding.add.color(y,        interactions.color, config);
    x_padded = model.data.padding.add.scale(x_padded, interactions.scale, config);
    y_padded = model.data.padding.add.scale(y_padded, interactions.scale, config);
end