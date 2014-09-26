function test_suite = test_rings
  initTestSuite;
end

%% TEST CRISPENING EFFECT

function test_crispening_effect_dwt
    % Given
    width = 64;
    A = test_image('crispening effect A', width);
    B = test_image('crispening effect B', width);
    C = test_image('crispening effect C', width);
    config                               = configurations.default_lab;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 10;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = false;
    config.zli.normal_type               = 'dims';
    % When
    [~, A_out] = model.apply(A, config);
    [~, B_out] = model.apply(B, config);
    [~, C_out] = model.apply(C, config);
    % Then
    I_max  = max(max(max(A_out(:), B_out(:)), C_out(:)));
    I_min  = min(min(min(A_out(:), B_out(:)), C_out(:)));
    I_lims = [I_min I_max];
    close all
    do_plot(1, 'L-D', I_lims, A_out(:,:,1))
    do_plot(2, 'R-G', I_lims, A_out(:,:,2))
    do_plot(3, 'B-Y', I_lims, A_out(:,:,3))
    do_plot(4, 'L-D', I_lims, B_out(:,:,1))
    do_plot(5, 'R-G', I_lims, B_out(:,:,2))
    do_plot(6, 'B-Y', I_lims, B_out(:,:,3))
    do_plot(7, 'L-D', I_lims, C_out(:,:,1))
    do_plot(8, 'R-G', I_lims, C_out(:,:,2))
    do_plot(9, 'B-Y', I_lims, C_out(:,:,3))
end

function test_crispening_effect_opp
    % Given
    width = 64;
    A = test_image('crispening effect A', width);
    B = test_image('crispening effect B', width);
    C = test_image('crispening effect C', width);
    config                               = configurations.default_rgby;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 10;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = false;
    config.zli.normal_type               = 'dims';
    % When
    [~, A_out] = model.apply(A, config);
    [~, B_out] = model.apply(B, config);
    [~, C_out] = model.apply(C, config);
    % Then
    A_out = collapse_opponents(A_out);
    B_out = collapse_opponents(B_out);
    C_out = collapse_opponents(C_out);
    I_max  = max(max(max(A_out(:), B_out(:)), C_out(:)));
    I_min  = min(min(min(A_out(:), B_out(:)), C_out(:)));
    I_lims = [I_min I_max];
    close all
    do_plot(1, 'L-D', I_lims, A_out(:,:,1))
    do_plot(2, 'R-G', I_lims, A_out(:,:,2))
    do_plot(3, 'B-Y', I_lims, A_out(:,:,3))
    do_plot(4, 'L-D', I_lims, B_out(:,:,1))
    do_plot(5, 'R-G', I_lims, B_out(:,:,2))
    do_plot(6, 'B-Y', I_lims, B_out(:,:,3))
    do_plot(7, 'L-D', I_lims, C_out(:,:,1))
    do_plot(8, 'R-G', I_lims, C_out(:,:,2))
    do_plot(9, 'B-Y', I_lims, C_out(:,:,3))
end

%% TEST CHROMATIC INDUCTION IN BARS EXAMPLE

function test_bars_dwt
    I = imresize(imread('tests/data/input/test_bars.png'), 0.08);
    mask = im2double(imresize(imread('tests/data/input/test_bars_mask.png'), 0.08));
    config                               = configurations.default_lab;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 10;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = true;
    config.zli.normal_type               = 'dims';
    % When
    [~, I_out] = model.apply(I, config);
    % Then
    I_max  = max(I_out(:));
    I_min  = min(I_out(:));
    I_lims = [I_min I_max];
    I_masked    = I_out .* mask;
    masked_max  = max(I_masked(:));
    masked_min  = min(I_masked(:));
    masked_lims = [masked_min masked_max];
    close all
    do_plot( 1, 'L-D', I_lims, I_out(:,:,1))
    do_plot( 2, 'R-G', I_lims, I_out(:,:,2))
    do_plot( 3, 'B-Y', I_lims, I_out(:,:,3))
    do_plot( 4, 'L-D', masked_lims, I_masked(:,:,1))
    do_plot( 5, 'R-G', masked_lims, I_masked(:,:,2))
    do_plot( 6, 'B-Y', masked_lims, I_masked(:,:,3))
end

function test_bars_opp
    I = imresize(imread('tests/data/input/test_bars.png'), 0.08);
    mask = im2double(imresize(imread('tests/data/input/test_bars_mask.png'), 0.08));
    config                               = configurations.default_rgby;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 10;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = true;
    config.zli.normal_type               = 'dims';
    % When
    [~, I_out] = model.apply(I, config);
    % Then
    I_out = collapse_opponents(I_out);
    I_max  = max(I_out(:));
    I_min  = min(I_out(:));
    I_lims = [I_min I_max];
    I_masked    = I_out .* mask;
    masked_max  = max(I_masked(:));
    masked_min  = min(I_masked(:));
    masked_lims = [masked_min masked_max];
    close all
    do_plot( 1, 'L-D', I_lims, I_out(:,:,1))
    do_plot( 2, 'R-G', I_lims, I_out(:,:,2))
    do_plot( 3, 'B-Y', I_lims, I_out(:,:,3))
    do_plot( 4, 'L-D', masked_lims, I_masked(:,:,1))
    do_plot( 5, 'R-G', masked_lims, I_masked(:,:,2))
    do_plot( 6, 'B-Y', masked_lims, I_masked(:,:,3))
end

%% TEST CHROMATIC INDUCTION IN GRADIENT EXAMPLE

function test_gradient_dwt
    I = imresize(imread('tests/data/input/test_gradient.png'), 0.5);
    mask = im2double(imresize(imread('tests/data/input/test_gradient_mask.png'), 0.5));
    config                               = configurations.default_lab;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 10;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = true;
    config.zli.normal_type               = 'dims';
    % When
    [~, I_out] = model.apply(I, config);
    % Then
    I_max  = max(I_out(:));
    I_min  = min(I_out(:));
    I_lims = [I_min I_max];
    I_masked    = I_out .* mask;
    masked_max  = max(I_masked(:));
    masked_min  = min(I_masked(:));
    masked_lims = [masked_min masked_max];
    close all
    do_plot( 1, 'L-D', I_lims, I_out(:,:,1))
    do_plot( 2, 'R-G', I_lims, I_out(:,:,2))
    do_plot( 3, 'B-Y', I_lims, I_out(:,:,3))
    do_plot( 4, 'L-D', masked_lims, I_masked(:,:,1))
    do_plot( 5, 'R-G', masked_lims, I_masked(:,:,2))
    do_plot( 6, 'B-Y', masked_lims, I_masked(:,:,3))
end

function test_gradient_opp
    I = imresize(imread('tests/data/input/test_gradient.png'), 0.5);
    mask = im2double(imresize(imread('tests/data/input/test_gradient_mask.png'), 0.5));
    config                               = configurations.default_rgby;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 10;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = true;
    config.zli.normal_type               = 'dims';
    % When
    [~, I_out] = model.apply(I, config);
    % Then
    I_out = collapse_opponents(I_out);
    I_max  = max(I_out(:));
    I_min  = min(I_out(:));
    I_lims = [I_min I_max];
    I_masked    = I_out .* mask;
    masked_max  = max(I_masked(:));
    masked_min  = min(I_masked(:));
    masked_lims = [masked_min masked_max];
    close all
    do_plot( 1, 'L-D', I_lims, I_out(:,:,1))
    do_plot( 2, 'R-G', I_lims, I_out(:,:,2))
    do_plot( 3, 'B-Y', I_lims, I_out(:,:,3))
    do_plot( 4, 'L-D', masked_lims, I_masked(:,:,1))
    do_plot( 5, 'R-G', masked_lims, I_masked(:,:,2))
    do_plot( 6, 'B-Y', masked_lims, I_masked(:,:,3))
end

%% TEST CHROMATIC INDUCTION IN RING EXAMPLES

function test_rings_a_dwt
    G    = imresize(imread('tests/data/input/test_circle_a_g.png'), 0.2); % Perceived greener
    B    = imresize(imread('tests/data/input/test_circle_a_b.png'), 0.2); % Perceived bluer
    mask = im2double(imresize(imread('tests/data/input/test_circle_a_mask.png'), 0.2));
    config                               = configurations.default_lab;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 10;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = true;
    config.zli.normal_type               = 'dims';
    % When
    [~, G_out] = model.apply(G, config);
    [~, B_out] = model.apply(B, config);
    % Then
    do_display(G_out, B_out, mask);
end

function test_rings_a_opp
    G = imresize(imread('tests/data/input/test_circle_a_g.png'), 0.2); % Perceived greener
    B = imresize(imread('tests/data/input/test_circle_a_b.png'), 0.2); % Perceived bluer
    mask = im2double(imresize(imread('tests/data/input/test_circle_a_mask.png'), 0.2));
    config                               = configurations.default_rgby;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 10;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = true;
    config.zli.normal_type               = 'dims';
    % When
    [~, G_out] = model.apply(G, config);
    [~, B_out] = model.apply(B, config);
    % Then
    G_out = collapse_opponents(G_out);
    B_out = collapse_opponents(B_out);
    do_display(G_out, B_out, mask);
end

function test_neon_rings_dwt
    % Given
    G = imresize(imread('tests/data/input/test_circle_neon_g.png'), 0.2); % Perceived greener
    B = imresize(imread('tests/data/input/test_circle_neon_b.png'), 0.2); % Perceived bluer
    mask = im2double(imresize(imread('tests/data/input/test_circle_neon_mask.png'), 0.2));
    config                               = configurations.default_lab;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 10;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = true;
    config.zli.normal_type               = 'dims';
    % When
    [~, G_out] = model.apply(G, config);
    [~, B_out] = model.apply(B, config);
    % Then
    do_display(G_out, B_out, mask);
end

function test_neon_rings_opp
    % Given
    G = imresize(imread('tests/data/input/test_circle_neon_g.png'), 0.2); % Perceived greener
    B = imresize(imread('tests/data/input/test_circle_neon_b.png'), 0.2); % Perceived bluer
    mask = im2double(imresize(imread('tests/data/input/test_circle_neon_mask.png'), 0.2));
    config                               = configurations.default_rgby;
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
    G_out = collapse_opponents(G_out);
    B_out = collapse_opponents(B_out);
    do_display(G_out, B_out, mask);
end

function do_display(G_out, B_out, mask)
    close all
    % Display the raw output
    lims_max = max(max(G_out(:)), max(B_out(:)));
    lims_min = min(min(G_out(:)), min(B_out(:)));
    lims     = [lims_min lims_max];
    do_plot( 1, 'Test Circle G L-D', lims, G_out(:,:,1))
    do_plot( 2, 'Test Circle G R-G', lims, G_out(:,:,2))
    do_plot( 3, 'Test Circle G B-Y', lims, G_out(:,:,3))
    do_plot( 4, 'Test Circle B L-D', lims, B_out(:,:,1))
    do_plot( 5, 'Test Circle B R-G', lims, B_out(:,:,2))
    do_plot( 6, 'Test Circle B B-Y', lims, B_out(:,:,3))
    % Mask all but the test ring and enhance the output
    G_masked = G_out .* mask;
    B_masked = B_out .* mask;
    lims_max = max(max(G_masked(:)), max(B_masked(:)));
    lims_min = min(min(G_masked(:)), min(B_masked(:)));
    lims     = [lims_min lims_max];
    do_plot( 7, 'Test Circle G L-D', lims, G_masked(:,:,1))
    do_plot( 8, 'Test Circle G R-G', lims, G_masked(:,:,2))
    do_plot( 9, 'Test Circle G B-Y', lims, G_masked(:,:,3))
    do_plot(10, 'Test Circle B L-D', lims, B_masked(:,:,1))
    do_plot(11, 'Test Circle B R-G', lims, B_masked(:,:,2))
    do_plot(12, 'Test Circle B B-Y', lims, B_masked(:,:,3))
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

function C = collapse_opponents(O)
% We get 6 channels from the opponent receptive field processing, we want 3
    O_odds  = O(:,:,1:2:6);
    O_evens = O(:,:,2:2:6);
    C       = O_odds - O_evens;
end