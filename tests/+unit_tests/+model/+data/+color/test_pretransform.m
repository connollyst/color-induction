function test_suite = test_pretransform
  initTestSuite;
end

%% ASSERT DATA FORMAT

function test_none_transform_data_format
    % Given
    [I_in, config] = get_input('none');
    % When
    I_out = model.data.color.pretransform(I_in, config);
    % Then
    assertIsDouble(I_out);
end

function test_rgb2lab_data_format
    % Given
    [I_in, config] = get_input('rgb2lab');
    % When
    I_out = model.data.color.pretransform(I_in, config);
    % Then
    assertIsDouble(I_out);
end

function test_rgb2rgby_data_format
    % Given
    [I_in, config] = get_input('rgb2rgby');
    % When
    I_out = model.data.color.pretransform(I_in, config);
    % Then
    assertIsDouble(I_out);
end

%% ASSERT DIMENSIONS

function test_none_transform_dimensions
    % Given
    [I_in, config] = get_input('none');
    n_cols     = size(I_in{1}, 1);
    n_rows     = size(I_in{1}, 2);
    n_channels = size(I_in{1}, 3);
    % When
    I_out = model.data.color.pretransform(I_in, config);
    % Then
    assertDimensions(I_out, [n_cols, n_rows, n_channels]);
end

function test_rgb2lab_transform_dimensions
    % Given
    [I_in, config] = get_input('rgb2lab');
    n_cols     = size(I_in{1}, 1);
    n_rows     = size(I_in{1}, 2);
    n_channels = 3; % L*, a*, & b*
    % When
    I_out = model.data.color.pretransform(I_in, config);
    % Then
    assertDimensions(I_out, [n_cols, n_rows, n_channels]);
end

function test_rgb2rgby_transform_dimensions
    % Given
    [I_in, config] = get_input('rgb2rgby');
    n_cols     = size(I_in{1}, 1);
    n_rows     = size(I_in{1}, 2);
    n_channels = 4; % R, G, B, & Y
    % When
    I_out = model.data.color.pretransform(I_in, config);
    % Then
    assertDimensions(I_out, [n_cols, n_rows, n_channels]);
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

function [I, config] = get_input(transform)
    im                         = little_peppers();
    config                     = configurations.default();
    config.display.logging     = false;
    config.display.plot        = false;
    config.image.transform.pre = transform;
    config.wave.n_scales       = 2;
    I = { im };
end