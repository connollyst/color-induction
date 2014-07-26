function test_suite = test_orient_padding
% When orient interactions are enabled, we expect padding be added to avoid
% edge effects when applying the convolution filter.
  initTestSuite;
end

function test_no_orient_padding_if_disabled
    % Given
    n_scales        = 2;
    n_orients       = 1;
    scale_enabled   = false;
    orient_enabled  = true;
    config          = get_config(42, 42, n_scales, n_orients, scale_enabled, orient_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add.orient(data, interactions.scale, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = n_scales;
    % TODO assert orients too
    assertEqual(actual_scales, expected_scales); % TODO this fails until we support disabling scales
end

function test_orient_padding_for_20x20
    n_cols           = 20;
    n_rows           = 20;
    n_orients        = 3;
    check_orient_padding(n_cols, n_rows, n_orients)
end

function test_orient_padding_for_30x40
    n_cols           = 30;
    n_rows           = 40;
    n_orients        = 3;
    check_orient_padding(n_cols, n_rows, n_orients)
end

function test_orient_padding_for_137x42
    n_cols           = 137;
    n_rows           = 42;
    n_orients        = 3;
    check_orient_padding(n_cols, n_rows, n_orients)
end

function test_error_padding_to_1_scales
    % Given
    n_scales        = 1;
    n_orients       = 1;
    scale_enabled   = true;
    orient_enabled  = true;
    config          = get_config(42, 42, n_scales, n_orients, scale_enabled, orient_enabled);
    % When/Then
    assertExceptionThrown(...
        @() model.terms.get_interactions(config), 'MODEL:scales'...
    );
end

function test_orient_padding_to_2_scales
    % Given
    n_scales        = 2;
    n_orients       = 1;
    scale_enabled   = true;
    orient_enabled  = true;
    config          = get_config(42, 42, n_scales, n_orients, scale_enabled, orient_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add.orient(data, interactions.scale, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = interactions.scale.n_interactions;
    assertEqual(actual_scales, expected_scales);
end

function test_orient_padding_to_3_scales
    % Given
    n_scales        = 3;
    n_orients       = 1;
    scale_enabled   = true;
    orient_enabled  = true;
    config          = get_config(42, 42, n_scales, n_orients, scale_enabled, orient_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add.orient(data, interactions.scale, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = interactions.scale.n_interactions;
    assertEqual(actual_scales, expected_scales);
end

function test_orient_padding_to_4_scales
    % Given
    n_scales        = 4;
    n_orients       = 1;
    scale_enabled   = true;
    orient_enabled  = true;
    config          = get_config(42, 42, n_scales, n_orients, scale_enabled, orient_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add.orient(data, interactions.scale, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = interactions.scale.n_interactions;
    assertEqual(actual_scales, expected_scales);
end

function test_orient_padding_to_5_scales
    % Given
    n_scales        = 5;
    n_orients       = 1;
    scale_enabled   = true;
    orient_enabled  = true;
    config          = get_config(42, 42, n_scales, n_orients, scale_enabled, orient_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add.orient(data, interactions.scale, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = interactions.scale.n_interactions;
    assertEqual(actual_scales, expected_scales);
end

function check_orient_padding(n_cols, n_rows, n_orients)
    % Given
    n_scales         = 2;
    orient_enabled   = true;
    scale_enabled    = true;
    config           = get_config(n_cols, n_rows, n_scales, n_orients, ...
                                            scale_enabled, orient_enabled);
    interactions     = model.terms.get_interactions(config);
    data             = model.utils.rand(config);
    % When
    padded           = model.data.padding.add.orient(data, interactions.scale, config);
    % Then
    assertPadding(padded, interactions, config);
end

%% ASSERTIONS

function assertPadding(padded, interactions, config)
    n_cols   = config.image.width;
    n_rows   = config.image.height;
    n_scales = config.wave.n_scales;
    distance = interactions.scale.distance;
    for s=distance+1:distance+n_scales
        delta = interactions.scale.deltas(s-distance);
        actual_cols = size(padded{s}, 1);
        actual_rows = size(padded{s}, 2);
        expected_cols = n_cols + delta * 2;
        expected_rows = n_rows + delta * 2;
        assertEqual(actual_cols, expected_cols, ['number of cols differ in s=',num2str(s)]);
        assertEqual(actual_rows, expected_rows, ['number of rows differ in s=',num2str(s)]);
    end
end

%% UTILITIES

function config = get_config(n_cols, n_rows, n_scales, n_orients, scale_enabled, orient_enabled)
    config = get_test_config(n_cols, n_rows, 2, n_scales);
    config.wave.n_orients = n_orients;
    config.zli.interaction.scale.enabled = scale_enabled;
    config.zli.interaction.orient.enabled = orient_enabled;
    if scale_enabled
        config.zli.interaction.scale.weight = 0.137;
    end
    config.compute.use_fft = false;
end