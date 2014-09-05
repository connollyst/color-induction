function test_suite = test_posttransform
  initTestSuite;
end

%% ASSERT DATA FORMAT

function test_none_posttransform_data_format
    % Given
    [I_in, config]        = get_input('none', 'none');
    I_opponent            = model.data.color.pretransform(I_in, config);
    [wavelets, residuals] = model.data.decomposition.apply(I_opponent, config);
    % When
    [wavelets, residuals] = model.data.color.posttransform(wavelets, residuals, config);
    % Then
    assertIsDouble(wavelets);
    assertIsDouble(residuals);
end

function test_rgby_posttransform_data_format
    % Given
    [I_in, config]        = get_input('none', 'rgb2rgby');
    I_opponent            = model.data.color.pretransform(I_in, config);
    [wavelets, residuals] = model.data.decomposition.apply(I_opponent, config);
    % When
    [wavelets, residuals] = model.data.color.posttransform(wavelets, residuals, config);
    % Then
    assertIsDouble(wavelets);
    assertIsDouble(residuals);
end

%% ASSERT DIMENSIONS

function test_none_transform_dimensions
    % Given
    [I_in, config]        = get_input('none', 'none');
    n_cols                = size(I_in{1}, 1);
    n_rows                = size(I_in{1}, 2);
    n_channels            = size(I_in{1}, 3);
    n_scales              = config.wave.n_scales;
    n_orients             = config.wave.n_orients;
    I_opponent            = model.data.color.pretransform(I_in, config);
    [wavelets, residuals] = model.data.decomposition.apply(I_opponent, config);
    % When
    [wavelets, residuals] = model.data.color.posttransform(wavelets, residuals, config);
    % Then
    assertDimensions(wavelets,  [n_cols, n_rows, n_channels, n_scales, n_orients]);
    assertDimensions(residuals, [n_cols, n_rows, n_channels, n_scales]);
end

function test_rgb2rgby_transform_dimensions
    % Given
    [I_in, config]        = get_input('none', 'rgb2rgby');
    n_cols                = size(I_in{1}, 1);
    n_rows                = size(I_in{1}, 2);
    n_channels            = 4; % R, G, B, & Y
    n_scales              = config.wave.n_scales;
    n_orients             = config.wave.n_orients;
    I_opponent            = model.data.color.pretransform(I_in, config);
    [wavelets, residuals] = model.data.decomposition.apply(I_opponent, config);
    % When
    [wavelets, residuals] = model.data.color.posttransform(wavelets, residuals, config);
    % Then
    assertDimensions(wavelets,  [n_cols, n_rows, n_channels, n_scales, n_orients]);
    assertDimensions(residuals, [n_cols, n_rows, n_channels, n_scales]);
end

%% TEST ASSERTIONS

function assertIsDouble(I)
    for i=1:length(I)
        assertTrue(isa(I{i},'double'));
    end
end

function assertDimensions(I, expected)
    for i=1:length(I)
        assertEqual(size(I{i}), expected);
    end
end

%% TEST UTILITIES

function [I, config] = get_input(pretransform, posttransform)
    im                          = imread('peppers.png');
    config                      = configurations.default();
    config.display.logging      = false;
    config.display.plot         = false;
    config.image.width          = size(im, 1);
    config.image.height         = size(im, 2);
    config.image.transform.pre  = pretransform;
    config.image.transform.post = posttransform;
    config.wave.n_scales        = 2;
    I = { im };
end