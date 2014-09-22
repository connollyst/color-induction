function test_suite = test_orient_padding
% When orient interactions are enabled, we expect padding be added to avoid
% edge effects when applying the convolution filter.
  initTestSuite;
end

function test_no_orient_padding_if_disabled
    % Given
    n_scales        = 2;
    scale_enabled   = false;
    orient_enabled  = false;
    config          = opponent_config(42, 42, n_scales, scale_enabled, orient_enabled);
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
    check_orient_padding(n_cols, n_rows)
end

function test_orient_padding_for_30x40
    n_cols           = 30;
    n_rows           = 40;
    check_orient_padding(n_cols, n_rows)
end

function test_orient_padding_for_137x42
    n_cols           = 137;
    n_rows           = 42;
    check_orient_padding(n_cols, n_rows)
end

function test_error_padding_to_1_scales
    % Given
    n_scales        = 1;
    scale_enabled   = true;
    orient_enabled  = true;
    config          = single_opponent_config(42, 42, n_scales, scale_enabled, orient_enabled);
    % When/Then
    assertExceptionThrown(...
        @() model.terms.get_interactions(config), 'MODEL:scales'...
    );
end

function test_orient_padding_to_2_scales
    % Given
    n_scales        = 2;
    scale_enabled   = true;
    orient_enabled  = true;
    config          = single_opponent_config(42, 42, n_scales, scale_enabled, orient_enabled);
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
    scale_enabled   = true;
    orient_enabled  = true;
    config          = single_opponent_config(42, 42, n_scales, scale_enabled, orient_enabled);
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
    scale_enabled   = true;
    orient_enabled  = true;
    config          = single_opponent_config(42, 42, n_scales, scale_enabled, orient_enabled);
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
    scale_enabled   = true;
    orient_enabled  = true;
    config          = single_opponent_config(42, 42, n_scales, scale_enabled, orient_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add.orient(data, interactions.scale, config);
    % Then
    actual_scales   = length(padded);
    expected_scales = interactions.scale.n_interactions;
    assertEqual(actual_scales, expected_scales);
end

function check_orient_padding(n_cols, n_rows)
    % Given
    n_scales         = 2;
    orient_enabled   = true;
    scale_enabled    = true;
    config           = double_opponent_config(n_cols, n_rows, n_scales, scale_enabled, orient_enabled);
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

function config = single_opponent_config(n_cols, n_rows, n_scales, scale_enabled, orient_enabled)
    config = opponent_config(n_cols, n_rows, n_scales, scale_enabled, orient_enabled);
    config.wave.n_orients = 1;
    config.rf.so.enabled = true;
    config.rf.do.enabled = false;
end

function config = double_opponent_config(n_cols, n_rows, n_scales, scale_enabled, orient_enabled)
    config = opponent_config(n_cols, n_rows, n_scales, scale_enabled, orient_enabled);
    config.wave.n_orients = 3;
    config.rf.so.enabled = false;
    config.rf.do.enabled = true;
end

function config = opponent_config(n_cols, n_rows, n_scales, scale_enabled, orient_enabled)
    n_channels = 4; % 2 pairs of opponent channels, eg: R, G, B, Y
    config = test_config(n_cols, n_rows, n_channels, n_scales);
    config.zli.interaction.scale.enabled = scale_enabled;
    config.zli.interaction.orient.enabled = orient_enabled;
    if scale_enabled
        config.zli.interaction.scale.weight = 0.137;
    end
    config.compute.use_fft = false;
end