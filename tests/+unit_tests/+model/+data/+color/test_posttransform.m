function test_suite = test_posttransform
  initTestSuite;
end

%% ASSERT DATA FORMAT

function test_none_transform_data_format
    % Given
    [I_in, config]        = get_input('none', 'rgb2rgby');
    I_opponent            = model.data.color.pretransform(I_in, config);
    [wavelets, residuals] = model.data.decomposition.apply(I_opponent, config);
    % When
    [wavelets, residuals] = model.data.color.posttransform(wavelets, residuals);
    % Then
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
    im                          = little_peppers();
    config                      = configurations.default();
    config.display.logging      = false;
    config.display.plot         = false;
    config.image.transform.pre  = pretransform;
    config.image.transform.post = posttransform;
    config.wave.n_scales        = 2;
    I = { im };
end