function test_suite = test_crispening_effect
  initTestSuite;
end

%% TEST CRISPENING EFFECT IN ITTI COLORSPACE

function test_itti
    % Given
    width                                = 48;
    [A, B, C]                            = test_images(width);
    config                               = configurations.default_rgby;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 5;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = false;
    % When
    [~, B_out] = model.apply(B, config);
    [~, A_out] = model.apply(A, config);
    [~, C_out] = model.apply(C, config);
    % Then
    assertCrispeningEffect(A_out, B_out, C_out, width);
end

function test_itti_double_opponent
    % Given
    width                                = 48;
    [A, B, C]                            = test_images(width);
    config                               = configurations.double_opponent_rgby;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 5;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = false;
    % When
    [~, A_out] = model.apply(A, config);
    [~, B_out] = model.apply(B, config);
    [~, C_out] = model.apply(C, config);
    % Then
    assertCrispeningEffect(A_out, B_out, C_out, width);
end

function test_itti_single_opponent
    % Given
    width                                = 48;
    [A, B, C]                            = test_images(width);
    config                               = configurations.single_opponent_rgby;
    config.display.logging               = false;
    config.display.plot                  = true;
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 5;
    config.zli.n_iter                    = 10;
    config.zli.interaction.color.enabled = false;
    % When
    [~, A_out] = model.apply(A, config);
    [~, B_out] = model.apply(B, config);
    [~, C_out] = model.apply(C, config);
    % Then
    assertCrispeningEffect(A_out, B_out, C_out, width);
end

%% TEST UTILITIES

function [A, B, C] = test_images(width)
    A = test_image('crispening effect A', width);
    B = test_image('crispening effect B', width);
    C = test_image('crispening effect C', width);
end

%% TEST ASSERTIONS

function assertCrispeningEffect(A, B, C, width)
% We should see that the top and bottom colored squares are most noticeably
% different from each other when placed on a background whose color is
% between the squares' colors. This backround drives the squares colors'
% apart, while a black or white background drives the colors toward each
% other.
    third_width    = floor(width/3);
    inner_cols     = third_width:width-third_width;
    inner_rows_one = inner_cols;
    inner_rows_two = inner_rows_one+width;
    A_one          = A(inner_rows_one, inner_cols, :);
    A_two          = A(inner_rows_two, inner_cols, :);
    B_one          = B(inner_rows_one, inner_cols, :);
    B_two          = B(inner_rows_two, inner_cols, :);
    C_one          = C(inner_rows_one, inner_cols, :);
    C_two          = C(inner_rows_two, inner_cols, :);
    A_mean_one     = mean(A_one(:));
    A_mean_two     = mean(A_two(:));
    B_mean_one     = mean(B_one(:));
    B_mean_two     = mean(B_two(:));
    C_mean_one     = mean(C_one(:));
    C_mean_two     = mean(C_two(:));
    A_mean_diff    = abs(A_mean_one - A_mean_two);
    B_mean_diff    = abs(B_mean_one - B_mean_two);
    C_mean_diff    = abs(C_mean_one - C_mean_two);
    assertTrue(B_mean_diff > A_mean_diff, ...
                'Test image B should show a greater difference than A.');
    assertTrue(B_mean_diff > C_mean_diff, ...
                'Test image B should show a greater difference than C.');
end
