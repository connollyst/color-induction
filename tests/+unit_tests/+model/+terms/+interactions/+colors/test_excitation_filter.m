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
    config.zli.interaction.color.weight  = 0.1;
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
    config.zli.interaction.color.weight  = 0.1;
    config.image.n_channels              = 2;
    % When
    actual_filter = model.terms.interactions.colors.excitation_filter(config);
    % Then
    expected_size   = 3;     % Note: rounded to 3 for symmetry
    expected_weight = 0.1;
    assertDefaultFilterSize(expected_size, actual_filter);
    assertDefaultFilterContents(expected_size, expected_weight, actual_filter);
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
    assertDefaultFilterContents(expected_size, expected_weight, actual_filter);
end

function test_default_color_excitation_filter_with_42_color_channel
    % Given
    config = struct();
    config.zli.interaction.color.enabled = true;
    config.zli.interaction.color.scheme  = 'default';
    config.zli.interaction.color.weight  = 0.5;
    config.image.n_channels              = 42;
    % When
    actual_filter = model.terms.interactions.colors.excitation_filter(config);
    % Then
    expected_size   = 43;   % Note: rounded to 43 for symmetry
    expected_weight = 0.5;
    assertDefaultFilterSize(expected_size, actual_filter);
    assertDefaultFilterContents(expected_size, expected_weight, actual_filter);
end

%% TEST OPPONENT COLOR INTERACTIONS


%% UTILITIES

function assertDefaultFilterSize(expected_length, actual_filter)
    actual_size = size(actual_filter);
    expected_size = [1 1 expected_length];
    assertEqual(expected_size, actual_size);
end

function assertDefaultFilterContents(expected_length, expected_weight, actual_filter)
% Assert filter contents (center)
    center_index = round(expected_length / 2);
    actual_center_value = actual_filter(1,1,center_index);
    expected_center_value = 1;
    assertEqual(expected_center_value, actual_center_value);
    % Assert filter contents (left)
    left_indices = 1:center_index-1;
    actual_left_filter_values = actual_filter(1,1,left_indices);
    actual_left_filter_values = reshape(actual_left_filter_values, 1, length(left_indices));
    expected_left_filter_values = ones(size(left_indices)) * expected_weight;
    assertEqual(expected_left_filter_values, actual_left_filter_values);
    % Assert filter contents (right)
    right_indices = center_index+1:expected_length;
    actual_right_filter_values = actual_filter(1,1,right_indices);
    actual_right_filter_values = reshape(actual_right_filter_values, 1, length(right_indices));
    expected_right_filter_values = ones(size(right_indices)) * expected_weight;
    assertEqual(size(expected_right_filter_values), size(actual_right_filter_values));
    assertEqual(expected_right_filter_values, actual_right_filter_values);
end