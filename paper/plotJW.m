function plotJW
    config = configurations.default;
    config.image.width      = 137;
    config.image.height     = 42;
    config.image.n_channels = 4;
    config.wave.n_scales    = 3;
    interactions = model.terms.get_interactions(config);
    % PLOT J
    J = interactions.orient.JW.J{3};
    clims = [-max(J(:)) -min(J(:))];
    do_plot( 1, clims, J(:,:,1,1,1));
    do_plot( 2, clims, J(:,:,1,2,1));
    do_plot( 3, clims, J(:,:,1,3,1));
    do_plot( 4, clims, J(:,:,1,4,1)*2);
    do_plot( 5, clims, J(:,:,1,1,2));
    do_plot( 6, clims, J(:,:,1,2,2));
    do_plot( 7, clims, J(:,:,1,3,2));
    do_plot( 8, clims, J(:,:,1,4,2)*2);
    do_plot( 9, clims, J(:,:,1,1,3));
    do_plot(10, clims, J(:,:,1,2,3));
    do_plot(11, clims, J(:,:,1,3,3));
    do_plot(12, clims, J(:,:,1,4,3)*2);
    do_plot(13, clims, J(:,:,1,1,4)*2);
    do_plot(14, clims, J(:,:,1,2,4)*2);
    do_plot(15, clims, J(:,:,1,3,4)*2);
    do_plot(17, clims, J(:,:,1,4,4)*2);
    % PLOT W
    W = interactions.orient.JW.W{3};
    clims = [-max(W(:)) -min(W(:))];
    do_plot(18, clims, W(:,:,1,1,1));
    do_plot(19, clims, W(:,:,1,2,1));
    do_plot(20, clims, W(:,:,1,3,1));
    do_plot(21, clims, W(:,:,1,4,1));
    do_plot(22, clims, W(:,:,1,1,2));
    do_plot(23, clims, W(:,:,1,2,2));
    do_plot(24, clims, W(:,:,1,3,2));
    do_plot(25, clims, W(:,:,1,4,2));
    do_plot(26, clims, W(:,:,1,1,3));
    do_plot(27, clims, W(:,:,1,2,3));
    do_plot(28, clims, W(:,:,1,3,3));
    do_plot(29, clims, W(:,:,1,4,3));
    do_plot(30, clims, W(:,:,1,1,4));
    do_plot(31, clims, W(:,:,1,2,4));
    do_plot(32, clims, W(:,:,1,3,4));
    do_plot(33, clims, W(:,:,1,4,4));
end

function do_plot(i, clims, data)
    cmap = hot;
    cmap(length(cmap),:) = [ 1 1 1 ];
    figure(i), colormap(cmap), imagesc(-data, clims)
    % Remove ticks
    set(gca, 'xtick', [] , 'ytick', [])
    % Remove padding
    set(gca,'position', [0 0 1 1], 'units', 'normalized')
end