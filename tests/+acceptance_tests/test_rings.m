function test_suite = test_rings
  initTestSuite;
end

%% TEST CHROMATIC INDUCTION IN RING EXAMPLES

function test_rings_a_dwt
    % Given
    G = imresize(imread('tests/data/input/test_circle_a_g.png'), 0.2); % Perceived greener
    B = imresize(imread('tests/data/input/test_circle_a_b.png'), 0.2); % Perceived bluer
    config                               = configurations.default_lab;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 20;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = true;
    config.zli.normal_type               = 'dims';
    % When
    [~, G_out] = model.apply(G, config);
    [~, B_out] = model.apply(B, config);
    % Then
    mask = im2double(imresize(imread('tests/data/input/test_circle_a_mask.png'), 0.2));
    G_masked = G_out .* mask;
    B_masked = B_out .* mask;
    lims_max = max(max(G_masked(:)), max(B_masked(:)));
    lims_min = min(min(G_masked(:)), min(B_masked(:)));
    lims     = [lims_min lims_max];
    do_plot(2, 'Test Circle G L-D', lims, G_masked(:,:,1))
    do_plot(3, 'Test Circle G R-G', lims, G_masked(:,:,2))
    do_plot(4, 'Test Circle G B-Y', lims, G_masked(:,:,3))
    do_plot(5, 'Test Circle B L-D', lims, B_masked(:,:,1))
    do_plot(6, 'Test Circle B R-G', lims, B_masked(:,:,2))
    do_plot(7, 'Test Circle B B-Y', lims, B_masked(:,:,3))
end

function test_neon_rings_dwt
    % Given
    G = imresize(imread('tests/data/input/test_circle_neon_g.png'), 0.2); % Perceived greener
    B = imresize(imread('tests/data/input/test_circle_neon_b.png'), 0.2); % Perceived bluer
    config                               = configurations.default_lab;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 20;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = true;
    config.zli.normal_type               = 'dims';
    % When
    [~, G_out] = model.apply(G, config);
    [~, B_out] = model.apply(B, config);
    % Then
    mask = im2double(imresize(imread('tests/data/input/test_circle_neon_mask.png'), 0.2));
    G_masked = G_out .* mask;
    B_masked = B_out .* mask;
    lims_max = max(max(G_masked(:)), max(B_masked(:)));
    lims_min = min(min(G_masked(:)), min(B_masked(:)));
    lims     = [lims_min lims_max];
    do_plot(2, 'Test Circle G L-D', lims, G_masked(:,:,1))
    do_plot(3, 'Test Circle G R-G', lims, G_masked(:,:,2))
    do_plot(4, 'Test Circle G B-Y', lims, G_masked(:,:,3))
    do_plot(5, 'Test Circle B L-D', lims, B_masked(:,:,1))
    do_plot(6, 'Test Circle B R-G', lims, B_masked(:,:,2))
    do_plot(7, 'Test Circle B B-Y', lims, B_masked(:,:,3))
end

function do_plot(i, t, clims, data)
    h = figure(i);
    colormap('gray');
    imagesc(data, clims);
    set(h, 'name', t);
    truesize(h, [size(data,1) size(data,2)]);
    set(gca, 'xtick', [] , 'ytick', []) % Remove ticks
    set(gca,'position', [0 0 1 1], 'units', 'normalized')   % Remove padding
end