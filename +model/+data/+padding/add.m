function [gx_padded, gy_padded] = add(x, y, interactions, config)
%PADDING.ADD Add padding to prevent edge effects.
    x_padded = model.data.padding.add.color(x, interactions.color, config);
    y_padded = model.data.padding.add.color(y, interactions.color, config);
    [gx_padded, gy_padded] = model.data.padding.add.scale( ...
                                x_padded, y_padded, interactions.scale, config ...
                             );
end
