function test_suite = test_color_padding
% When color interactions are enabled, we expect padding be added to avoid
% edge effects when applying the convolution filter.
  initTestSuite;
end

function test_no_color_padding_if_disabled
    % Given
    actual_colors   = 4;
    color_enabled   = false;
    config          = get_config(actual_colors, color_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    expected_colors = 4;
    assertColorSizes(padded, expected_colors);
end

function test_color_padding_to_2_colors
    % Given
    actual_colors   = 2;
    color_enabled   = true;
    config          = get_config(actual_colors, color_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    expected_colors = actual_colors * 2;
    assertColorSizes(padded, expected_colors);
end

function test_color_padding_to_4_colors
    % Given
    actual_colors   = 4;
    color_enabled   = true;
    config          = get_config(actual_colors, color_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    expected_colors = actual_colors * 2;
    assertColorSizes(padded, expected_colors);
end

function test_color_padding_to_6_colors
    % Given
    actual_colors   = 6;
    color_enabled   = true;
    config          = get_config(actual_colors, color_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    expected_colors = actual_colors * 2;
    assertColorSizes(padded, expected_colors);
end

function test_color_padding_to_42_colors
    % Given
    actual_colors   = 42;
    color_enabled   = true;
    config          = get_config(actual_colors, color_enabled);
    interactions    = model.terms.get_interactions(config);
    data            = model.utils.rand(config);
    % When
    padded          = model.data.padding.add(data, interactions, config);
    % Then
    expected_colors = actual_colors * 2;
    assertColorSizes(padded, expected_colors);
end

%% ASSERTIONS

function assertColorSizes(padded, expected_colors)
    for i=length(padded)
        actual_colors = size(padded{i}, 3);
        assertEqual(actual_colors, expected_colors, '');
    end
end

%% UTILITIES

function config = get_config(colors, color_enabled)
    config = get_test_config(42, 42, colors, 2);
    config.zli.interaction.color.enabled = color_enabled;
    if color_enabled
        config.zli.interaction.color.weight.excitation = 0.1;
        config.zli.interaction.color.weight.inhibition = 0.2;
    end
end