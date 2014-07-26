function test_suite = test_regression_padding
% Regression tests for padding.
% We have known input and output from the original code and expect the
% exact same functionality when color interactions are disabled.
  initTestSuite;
end

function test_gx_padded_3D_t01_i01
    assert_gx_padded('3D_t01_i01');
end

function test_gy_padded_3D_t01_i01
    assert_gy_padded('3D_t01_i01');
end

function test_gx_padded_3D_t01_i02
    assert_gx_padded('3D_t01_i02');
end

function test_gy_padded_3D_t01_i02
    assert_gy_padded('3D_t01_i02');
end

function test_gx_padded_3D_t01_i03
    assert_gx_padded('3D_t01_i03');
end

function test_gy_padded_3D_t01_i03
    assert_gy_padded('3D_t01_i03');
end

function test_gx_padded_3D_t04_i01
    assert_gx_padded('3D_t04_i01');
end

function test_gy_padded_3D_t04_i01
    assert_gy_padded('3D_t04_i01');
end

%% ASSERTIONS

function assert_gx_padded(instance)
    % Given
    [gx, ~, interactions, config] = get_input(instance);
    % When
    gx_padded = model.data.padding.add.orient(gx, interactions.scale, config);
    % Then
    expected = get_output(instance);
    assertEqualData(gx_padded, expected.newgx_toroidal_x);
end

function assert_gy_padded(instance)
    % Given
    [~, gy, interactions, config] = get_input(instance);
    % When
    gy_padded = model.data.padding.add.orient(gy, interactions.scale, config);
    % Then
    expected = get_output(instance);
    assertEqualData(gy_padded, expected.newgy_toroidal_y);
end

%% TEST UTILITIES

function [gx, gy, interactions, config] = get_input(instance)
    input        = load(['data/input/update_xy_',instance,'.mat']);
    x            = input.x;
    y            = input.y;
    gx           = model.terms.gx(x);
    gy           = model.terms.gy(y);
    config       = get_test_config(40, 40, 3, 2);
    interactions = model.terms.get_interactions(config);
end

function output = get_output(instance)
    output = load(['data/expected/add_padding_',instance,'.mat']);
end