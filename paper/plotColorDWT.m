function plotColorDWT
    I = im2double(imresize(imread('peppers.png'), 0.5));
    % CONFIGURATION
    config = configurations.default_lab;
    config.wave.n_scales  = 3;
    % DECOMPOSE
    [wavelets, ~, ~] = model.data.prepare_input(I, config);
    wavelets = wavelets{1};
    close all
    % PLOT SCALE 1
    do_plot(101, 'Lso s=1',   wavelets(:,:,1,1,4));
    do_plot(102, 'Dso s=1',   wavelets(:,:,2,1,4));
    do_plot(103, 'Rso s=1',   wavelets(:,:,3,1,4));
    do_plot(104, 'Gso s=1',   wavelets(:,:,4,1,4));
    do_plot(105, 'Bso s=1',   wavelets(:,:,5,1,4));
    do_plot(106, 'Yso s=1',   wavelets(:,:,6,1,4));
    do_plot(107, 'Ldo-h s=1', wavelets(:,:,1,1,1));
    do_plot(108, 'Ddo-h s=1', wavelets(:,:,2,1,1));
    do_plot(109, 'Rdo-h s=1', wavelets(:,:,3,1,1));
    do_plot(110, 'Gdo-h s=1', wavelets(:,:,4,1,1));
    do_plot(111, 'Bdo-h s=1', wavelets(:,:,5,1,1));
    do_plot(112, 'Ydo-h s=1', wavelets(:,:,6,1,1));
    do_plot(113, 'Ldo-d s=1', wavelets(:,:,1,1,2));
    do_plot(114, 'Ddo-d s=1', wavelets(:,:,2,1,2));
    do_plot(115, 'Rdo-d s=1', wavelets(:,:,3,1,2));
    do_plot(116, 'Gdo-d s=1', wavelets(:,:,4,1,2));
    do_plot(117, 'Bdo-d s=1', wavelets(:,:,5,1,2));
    do_plot(118, 'Ydo-d s=1', wavelets(:,:,6,1,2));
    do_plot(119, 'Ldo-v s=1', wavelets(:,:,1,1,3));
    do_plot(120, 'Ddo-v s=1', wavelets(:,:,2,1,3));
    do_plot(121, 'Rdo-v s=1', wavelets(:,:,3,1,3));
    do_plot(122, 'Gdo-v s=1', wavelets(:,:,4,1,3));
    do_plot(123, 'Bdo-v s=1', wavelets(:,:,5,1,3));
    do_plot(124, 'Ydo-v s=1', wavelets(:,:,6,1,3));
    % PLOT SCALE 2
    do_plot(201, 'Lso s=2',   wavelets(:,:,1,2,4));
    do_plot(202, 'Dso s=2',   wavelets(:,:,2,2,4));
    do_plot(203, 'Rso s=2',   wavelets(:,:,3,2,4));
    do_plot(204, 'Gso s=2',   wavelets(:,:,4,2,4));
    do_plot(205, 'Bso s=2',   wavelets(:,:,5,2,4));
    do_plot(206, 'Yso s=2',   wavelets(:,:,6,2,4));
    do_plot(207, 'Ldo-h s=2', wavelets(:,:,1,2,1));
    do_plot(208, 'Ddo-h s=2', wavelets(:,:,2,2,1));
    do_plot(209, 'Rdo-h s=2', wavelets(:,:,3,2,1));
    do_plot(210, 'Gdo-h s=2', wavelets(:,:,4,2,1));
    do_plot(211, 'Bdo-h s=2', wavelets(:,:,5,2,1));
    do_plot(212, 'Ydo-h s=2', wavelets(:,:,6,2,1));
    do_plot(213, 'Ldo-d s=2', wavelets(:,:,1,2,2));
    do_plot(214, 'Ddo-d s=2', wavelets(:,:,2,2,2));
    do_plot(215, 'Rdo-d s=2', wavelets(:,:,3,2,2));
    do_plot(216, 'Gdo-d s=2', wavelets(:,:,4,2,2));
    do_plot(217, 'Bdo-d s=2', wavelets(:,:,5,2,2));
    do_plot(218, 'Ydo-d s=2', wavelets(:,:,6,2,2));
    do_plot(219, 'Ldo-v s=2', wavelets(:,:,1,2,3));
    do_plot(220, 'Ddo-v s=2', wavelets(:,:,2,2,3));
    do_plot(221, 'Rdo-v s=2', wavelets(:,:,3,2,3));
    do_plot(222, 'Gdo-v s=2', wavelets(:,:,4,2,3));
    do_plot(223, 'Bdo-v s=2', wavelets(:,:,5,2,3));
    do_plot(224, 'Ydo-v s=2', wavelets(:,:,6,2,3));
    % PLOT SCALE 3
    do_plot(301, 'Lso s=3',   wavelets(:,:,1,3,4));
    do_plot(302, 'Dso s=3',   wavelets(:,:,2,3,4));
    do_plot(303, 'Rso s=3',   wavelets(:,:,3,3,4));
    do_plot(304, 'Gso s=3',   wavelets(:,:,4,3,4));
    do_plot(305, 'Bso s=3',   wavelets(:,:,5,3,4));
    do_plot(306, 'Yso s=3',   wavelets(:,:,6,3,4));
    do_plot(307, 'Ldo-h s=3', wavelets(:,:,1,3,1));
    do_plot(308, 'Ddo-h s=3', wavelets(:,:,2,3,1));
    do_plot(309, 'Rdo-h s=3', wavelets(:,:,3,3,1));
    do_plot(310, 'Gdo-h s=3', wavelets(:,:,4,3,1));
    do_plot(311, 'Bdo-h s=3', wavelets(:,:,5,3,1));
    do_plot(312, 'Ydo-h s=3', wavelets(:,:,6,3,1));
    do_plot(313, 'Ldo-d s=3', wavelets(:,:,1,3,2));
    do_plot(314, 'Ddo-d s=3', wavelets(:,:,2,3,2));
    do_plot(315, 'Rdo-d s=3', wavelets(:,:,3,3,2));
    do_plot(316, 'Gdo-d s=3', wavelets(:,:,4,3,2));
    do_plot(317, 'Bdo-d s=3', wavelets(:,:,5,3,2));
    do_plot(318, 'Ydo-d s=3', wavelets(:,:,6,3,2));
    do_plot(319, 'Ldo-v s=3', wavelets(:,:,1,3,3));
    do_plot(320, 'Ddo-v s=3', wavelets(:,:,2,3,3));
    do_plot(321, 'Rdo-v s=3', wavelets(:,:,3,3,3));
    do_plot(322, 'Gdo-v s=3', wavelets(:,:,4,3,3));
    do_plot(323, 'Bdo-v s=3', wavelets(:,:,5,3,3));
    do_plot(324, 'Ydo-v s=3', wavelets(:,:,6,3,3));
end

function do_plot(i, t, data)
    h = figure(i);
    colormap('gray');
    imagesc(data);
    set(h, 'name', t);
    set(gca, 'xtick', [] , 'ytick', []) % Remove ticks
    set(gca,'position', [0 0 1 1], 'units', 'normalized')   % Remove padding
end