function plotRF()
    close all
    %plotso(1, 1.0, 0.5, 1.0, 0.5, 32, 32)
    plotso(2, 1.0, 0.5, 0.4, 0.5, 18, 46)
    %plotso(3, 1.0, 0.5, 1.0, 0.8,  8, 55)
    %plotdo(4, 1.0, 0.7, 0.7, 1.0, 0.7, 0.7, 4,  0, 64)
    %plotdo(5, 1.0, 0.7, 0.7, 1.0, 0.7, 0.7, 4, 64,  0)
    %plotdo(6, 0.4, 0.7, 0.7, 0.4, 0.7, 0.7, 4, 64,  0)
    %plotdo(7, 0.4, 0.7, 1.0, 0.4, 0.7, 1.0, 4, 64,  0)
    %plotdog(3, 1.0, 0.5, 1.0, 1,  8, 55)
end

function plotso(i, c_weight, c_width, s_weight, s_width, g, r)
    % CONFIGURATION
    config = configurations.default;
    config.rf.so.size            = 50;
    config.rf.so.center.width    = c_width;
    config.rf.so.center.weight   = c_weight;
    config.rf.so.surround.width  = s_width;
    config.rf.so.surround.weight = s_weight;
    
    % RECEPTIVE FIELDS
    c = model.data.rf.center(4, config);
    s = model.data.rf.surround(4, config);
    
    % PLOT
    red   = [255  83  83]/255;
    green = [ 60 160 140]/255;
    f     = figure(i);
    set(f, 'Color', [1 1 1])
    hold on
    surf( c, 'EdgeColor', 'none')
    surf(-s, 'EdgeColor', 'none')
    colormap([repmat(green, g, 1); repmat(red, r, 1)]);
    view(90,0)
    axis off
    axis([-50 50 -30 70 -0.011 0.011])
    hold off
end

function plotdo(i, c_weight, c_length, c_width, s_weight, s_length, s_width, offset, g, r)
    % CONFIGURATION
    config = configurations.default;
    config.rf.do.center.weight   = c_weight;
    config.rf.do.center.length   = c_length;
    config.rf.do.center.width    = c_width;
    config.rf.do.center.offset   = offset;
    config.rf.do.surround.weight = s_weight;
    config.rf.do.surround.length = s_length;
    config.rf.do.surround.width  = s_width;
    config.rf.do.surround.offset = offset;
    
    % RECEPTIVE FIELDS
    c = model.data.rf.oriented.center_middle_left(2, config);
    s = model.data.rf.oriented.surround_middle_right(2, config);
    
    % PLOT
    red   = [255  83  83]/255;
    green = [ 60 160 140]/255;
    f     = figure(i);
    set(f, 'Color', [1 1 1])
    hold on
    surf(c-s, 'EdgeColor', 'none')
    colormap([repmat(green, g, 1); repmat(red, r, 1)]);
    view(180,0)
    axis off
    axis([0 50 0 50 -0.05 0.05])
    hold off
end

function plotdog(i, c_weight, c_width, s_weight, s_width, g, r)
    % CONFIGURATION
    config = configurations.default;
    config.rf.do.size            = 500;
    config.rf.do.center.width    = c_width;
    config.rf.do.center.weight   = c_weight;
    config.rf.do.surround.width  = s_width;
    config.rf.do.surround.weight = s_weight;
    
    % RECEPTIVE FIELDS
    c = model.data.rf.center(4, config);
    s = model.data.rf.surround(4, config);
    
    % PLOT
    red   = [255  83  83]/255;
    green = [ 60 160 140]/255;
    f     = figure(i);
    set(f, 'Color', [1 1 1])
    hold on
    surf(c-s)%, 'EdgeColor', 'none')
    %colormap([repmat(green, g, 1); repmat(red, r, 1)]);
    %view(90,0)
    %axis off
    %axis([-50 50 -30 70 -0.011 0.011])
    hold off
end