function test_suite = test_scale_padding
% When scale interactions are enabled, we expect padding be added to avoid
% edge effects when applying the convolution filter.
  initTestSuite;
end

function test_no_scale_padding_if_disabled
    % Given
    n_scales        = 2;
    scale_enabled   = false;
    config          = get_config(n_scales, scale_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = n_scales;
    assertEqual(actual_scales, expected_scales);
end

function test_error_padding_to_1_scales
    % Given
    n_scales        = 1;
    scale_enabled   = true;
    config          = get_config(n_scales, scale_enabled);
    % When/Then
    assertExceptionThrown(...
        @() model.terms.get_interactions(config), 'MODEL:scales'...
    );
end

function test_scale_padding_to_2_scales
    % Given
    n_scales        = 2;
    scale_enabled   = true;
    config          = get_config(n_scales, scale_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = interactions.scale.n_interactions;
    assertEqual(actual_scales, expected_scales);
end

function test_scale_padding_to_3_scales
    % Given
    n_scales        = 3;
    scale_enabled   = true;
    config          = get_config(n_scales, scale_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = interactions.scale.n_interactions;
    assertEqual(actual_scales, expected_scales);
end

function test_scale_padding_to_4_scales
    % Given
    n_scales        = 4;
    scale_enabled   = true;
    config          = get_config(n_scales, scale_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = interactions.scale.n_interactions;
    assertEqual(actual_scales, expected_scales);
end

function test_scale_padding_to_5_scales
    % Given
    n_scales        = 5;
    scale_enabled   = true;
    config          = get_config(n_scales, scale_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = interactions.scale.n_interactions;
    assertEqual(actual_scales, expected_scales);
end

%% UTILITIES

function config = get_config(scales, scale_enabled)
    config = get_test_config(42, 42, 2, scales);
    config.zli.interaction.scale.enabled = scale_enabled;
    if scale_enabled
        config.zli.interaction.scale.weight = 0.137;
    end
    % TODO this is a hack, remove it soon!
    %      if n_orients=3, J & W take a long time to generate
    config.wave.n_orients = 1;
    config.compute.use_fft = false;
end