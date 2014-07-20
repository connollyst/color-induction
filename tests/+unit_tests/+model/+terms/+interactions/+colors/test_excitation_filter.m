function test_suite = test_excitation_filter
  initTestSuite;
end

%% TEST NO COLOR INTERACTIONS

function test_no_color_excitation_filter_when_disabled
    % Given
    config = struct();
    config.zli.interaction.color.enabled = false;
    % When
    actual_filter = model.terms.interactions.colors.excitation_filter(config);
    % Then
    expected_filter = 1;
    assertEqual(expected_filter, actual_filter);
end

%% TEST DEFAULT COLOR INTERACTIONS

function test_default_color_excitation_filter_with_1_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    config.zli.interaction.color.weight  = 0.3;
    config.image.n_channels              = 1;
    % When
    actual_filter = model.terms.interactions.colors.excitation_filter(config);
    % Then
    expected_filter = 1;
    assertEqual(expected_filter, actual_filter);
end

function test_default_color_excitation_filter_with_2_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    config.zli.interaction.color.weight  = 0.2;
    config.image.n_channels              = 2;
    % When
    actual_filter = model.terms.interactions.colors.excitation_filter(config);
    % Then
    expected_size   = 3;     % Note: rounded to 3 for symmetry
    expected_weight = 0.2;
    assertDefaultFilterSize(expected_size, actual_filter);
    assertDefaultFilterValues(expected_size, expected_weight, actual_filter);
end

function test_default_color_excitation_filter_with_3_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    config.zli.interaction.color.weight  = 0.1;
    config.image.n_channels              = 3;
    % When
    actual_filter = model.terms.interactions.colors.excitation_filter(config);
    % Then
    expected_size   = 3;
    expected_weight = 0.1;
    assertDefaultFilterSize(expected_size, actual_filter);
    assertDefaultFilterValues(expected_size, expected_weight, actual_filter);
end

function test_default_color_excitation_filter_with_42_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    config.zli.interaction.color.weight  = 0.05;
    config.image.n_channels              = 42;
    % When
    actual_filter = model.terms.interactions.colors.excitation_filter(config);
    % Then
    expected_size   = 43;   % Note: rounded to 43 for symmetry
    expected_weight = 0.05;
    assertDefaultFilterSize(expected_size, actual_filter);
    assertDefaultFilterValues(expected_size, expected_weight, actual_filter);
end

%% TEST OPPONENT COLOR INTERACTIONS

function test_opponent_color_excitation_filter_with_1_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'opponent';
    config.zli.interaction.color.weight  = 0.3;
    config.image.n_channels              = 1;
    % When/Then
    assertExceptionThrown(...
        @() model.terms.interactions.colors.excitation_filter(config),...
        'MODEL:config');
end

function test_opponent_color_excitation_filter_with_2_color_channels
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'opponent';
    config.zli.interaction.color.weight  = 0.2;
    config.image.n_channels              = 2;
    % When
    actual_filter = model.terms.interactions.colors.excitation_filter(config);
    % Then
    expected_weight = 0.2;
    assertOpponentFilterSize(actual_filter)
    assertOpponentFilterValues(expected_weight, actual_filter)
end

function test_opponent_color_excitation_filter_with_3_color_channels
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'opponent';
    config.zli.interaction.color.weight  = 0.1;
    config.image.n_channels              = 3;
    % When/Then
    assertExceptionThrown(...
        @() model.terms.interactions.colors.excitation_filter(config),...
        'MODEL:config');
end

function test_opponent_color_excitation_filter_with_42_color_channels
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'opponent';
    config.zli.interaction.color.weight  = 0.05;
    config.image.n_channels              = 42;
    % When
    actual_filter = model.terms.interactions.colors.excitation_filter(config);
    % Then
    expected_weight = 0.05;
    assertOpponentFilterSize(actual_filter)
    assertOpponentFilterValues(expected_weight, actual_filter)
end

%% ASSERTIONS

function assertDefaultFilterSize(expected_length, actual_filter)
    actual_size = size(actual_filter);
    expected_size = [1 1 expected_length];
    assertEqual(expected_size, actual_size);
end

function assertDefaultFilterValues(expected_length, expected_weight, actual_filter)
    % Assert filter contents (center)
    center_index = round(expected_length / 2);
    assertFilterSubsetValues(1, actual_filter, center_index)
    % Assert filter contents (left)
    left_indices = 1:center_index-1;
    assertFilterSubsetValues(expected_weight, actual_filter, left_indices)
    % Assert filter contents (right)
    right_indices = center_index+1:expected_length;
    assertFilterSubsetValues(expected_weight, actual_filter, right_indices)
end

function assertFilterSubsetValues(expected_value, filter, subset)
    actual_filter_subset_values = reshape(filter(1,1,subset), 1, length(subset));
    expected_filter_subset_values = ones(size(subset)) * expected_value;
    assertEqual(expected_filter_subset_values, actual_filter_subset_values);
end

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