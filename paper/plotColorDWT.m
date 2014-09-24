function plotColorDWT
    I_scale = 1;
    I = im2double(imresize(imread('peppers.png'), I_scale));
    % CONFIGURATION
    config = configurations.default_lab;
    config.wave.n_scales  = 3;
    % DECOMPOSE
    [wavelets, ~, ~] = model.data.prepare_input(I, config);
    wavelets = wavelets{1};
    % PLOT
    do_plot( 1, 'Lso s=1',   -wavelets(:,:,1,1,4));
    do_plot( 2, 'Dso s=1',   -wavelets(:,:,2,1,4));
    do_plot( 3, 'Rso s=1',   -wavelets(:,:,3,1,4));
    do_plot( 4, 'Gso s=1',   -wavelets(:,:,4,1,4));
    do_plot( 5, 'Bso s=1',   -wavelets(:,:,5,1,4));
    do_plot( 6, 'Yso s=1',   -wavelets(:,:,6,1,4));
    
    do_plot( 7, 'Ldo-h s=1', -wavelets(:,:,1,1,1));
    do_plot( 8, 'Ddo-h s=1', -wavelets(:,:,2,1,1));
    do_plot( 9, 'Rdo-h s=1', -wavelets(:,:,3,1,1));
    do_plot(10, 'Gdo-h s=1', -wavelets(:,:,4,1,1));
    do_plot(11, 'Bdo-h s=1', -wavelets(:,:,5,1,1));
    do_plot(12, 'Ydo-h s=1', -wavelets(:,:,6,1,1));
    
    do_plot(13, 'Ldo-d s=1', -wavelets(:,:,1,1,2));
    do_plot(14, 'Ddo-d s=1', -wavelets(:,:,2,1,2));
    do_plot(15, 'Rdo-d s=1', -wavelets(:,:,3,1,2));
    do_plot(16, 'Gdo-d s=1', -wavelets(:,:,4,1,2));
    do_plot(17, 'Bdo-d s=1', -wavelets(:,:,5,1,2));
    do_plot(18, 'Ydo-d s=1', -wavelets(:,:,6,1,2));
    
    do_plot(19, 'Ldo-v s=1', -wavelets(:,:,1,1,3));
    do_plot(20, 'Ddo-v s=1', -wavelets(:,:,2,1,3));
    do_plot(21, 'Rdo-v s=1', -wavelets(:,:,3,1,3));
    do_plot(22, 'Gdo-v s=1', -wavelets(:,:,4,1,3));
    do_plot(23, 'Bdo-v s=1', -wavelets(:,:,5,1,3));
    do_plot(24, 'Ydo-v s=1', -wavelets(:,:,6,1,3));
end

function do_plot(i, t, data)
    h = figure(i);
    colormap('gray');
    imagesc(data);
    set(h, 'name', t);
    set(gca, 'xtick', [] , 'ytick', []) % Remove ticks
    set(gca,'position', [0 0 1 1], 'units', 'normalized')   % Remove padding
end