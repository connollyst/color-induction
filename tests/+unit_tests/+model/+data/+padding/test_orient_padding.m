function test_suite = test_orient_padding
% When orient interactions are enabled, we expect padding be added to avoid
% edge effects when applying the convolution filter.
  initTestSuite;
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

function check_orient_padding(n_cols, n_rows, n_orients)
    % Given
    orient_enabled   = true;
    config           = get_config(n_cols, n_rows, n_orients, orient_enabled);
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

function config = get_config(n_cols, n_rows, n_orients, orient_enabled)
    config = get_test_config(n_cols, n_rows, 2, 2);
    config.wave.n_orients = n_orients;
    config.zli.interaction.orient.enabled = orient_enabled;
end