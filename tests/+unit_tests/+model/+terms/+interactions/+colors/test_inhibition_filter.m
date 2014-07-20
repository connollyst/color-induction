function test_suite = test_inhibition_filter
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_inhibition_filter_when_disabled
    % Given
    config = struct();
    config.zli.interaction.color.enabled = false;
    % When
    actual_filter = model.terms.interactions.colors.inhibition_filter(config);
    % Then
    expected_filter = 1;
    assertEqual(expected_filter, actual_filter);
end

%% TEST DEFAULT COLOR INTERACTIONS

function test_default_color_inhibition_filter_with_1_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    config.image.n_channels              = 1;
    % When
    actual_filter = model.terms.interactions.colors.inhibition_filter(config);
    % Then
    expected_filter = 1;
    assertEqual(expected_filter, actual_filter);
end

function test_default_color_inhibition_filter_with_2_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    config.image.n_channels              = 2;
    % When
    actual_filter = model.terms.interactions.colors.inhibition_filter(config);
    % Then
    expected_filter = 1;
    assertEqual(expected_filter, actual_filter);
end

function test_default_color_inhibition_filter_with_3_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    config.image.n_channels              = 3;
    % When
    actual_filter = model.terms.interactions.colors.inhibition_filter(config);
    % Then
    expected_filter = 1;
    assertEqual(expected_filter, actual_filter);
end

function test_default_color_inhibition_filter_with_42_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    config.image.n_channels              = 42;
    % When
    actual_filter = model.terms.interactions.colors.inhibition_filter(config);
    % Then
    expected_filter = 1;
    assertEqual(expected_filter, actual_filter);
end

%% TEST OPPONENT COLOR INTERACTIONS

function test_opponent_color_inhibition_filter_with_1_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.scheme            = 'opponent';
    config.zli.interaction.color.weight.inhibition = 0.3;
    config.image.n_channels                        = 1;
    % When/Then
    assertExceptionThrown(...
        @() model.terms.interactions.colors.inhibition_filter(config),...
        'MODEL:config');
end

function test_opponent_color_inhibition_filter_with_2_color_channels
    % Given
    config = struct();
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.scheme            = 'opponent';
    config.zli.interaction.color.weight.inhibition = 0.2;
    config.image.n_channels                        = 2;
    % When
    actual_filter = model.terms.interactions.colors.inhibition_filter(config);
    % Then
    expected_weight = 0.2;
    assertOpponentFilterSize(actual_filter)
    assertOpponentFilterValues(expected_weight, actual_filter)
end

function test_opponent_color_inhibition_filter_with_3_color_channels
    % Given
    config = struct();
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.scheme            = 'opponent';
    config.zli.interaction.color.weight.inhibition = 0.1;
    config.image.n_channels                        = 3;
    % When/Then
    assertExceptionThrown(...
        @() model.terms.interactions.colors.inhibition_filter(config),...
        'MODEL:config');
end

function test_opponent_color_inhibition_filter_with_42_color_channels
    % Given
    config = struct();
    config.zli.interaction.color.enabled           = true;
    config.zli.interaction.color.scheme            = 'opponent';
    config.zli.interaction.color.weight.inhibition = 0.05;
    config.image.n_channels                        = 42;
    % When
    actual_filter = model.terms.interactions.colors.inhibition_filter(config);
    % Then
    expected_weight = 0.05;
    assertOpponentFilterSize(actual_filter)
    assertOpponentFilterValues(expected_weight, actual_filter)
end

%% ASSERTIONS

function assertOpponentFilterSize(actual_filter)
    actual_size   = size(actual_filter);
    expected_size = [1 1 3];
    assertEqual(expected_size, actual_size);
end

function assertOpponentFilterValues(expected_weight, actual_filter)
    actual_values = reshape(actual_filter, 1, 3);
    expected_values = [expected_weight, 1, expected_weight];
    assertEqual(expected_values, actual_values);
end