function test_suite = test_calculate_xy
%TEST_ADD_PADDING Test suite for model.calculate_xy()
  initTestSuite;
end

function test_x_out_01
    assert_x_out('01')
end

function test_y_out_01
    assert_y_out('01')
end

%% ASSERTIONS

function assert_x_out(instance)
    [tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config] = get_input(instance);
    [x_out, ~] = model.calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    expected = get_expected(instance);
    assertEqualMatrices(x_out, expected.x);
end

function assert_y_out(instance)
    [tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config] = get_input(instance);
    [~, y_out] = model.calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    expected = get_expected(instance);
    assertEqualMatrices(y_out, expected.y);
end

%% TEST UTILITIES

function [tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config] = get_input(instance)
    input    = load(['data/input_to_calculate_xy_',instance,'.mat']);
    tIitheta = addColorDimension(input.Iitheta{1}); % TODO get correct frame
    I_norm   = addColorDimension(input.I_norm);
    x        = addColorDimension(input.x);
    y        = addColorDimension(input.y);
    x_ee     = addColorDimension(input.x_ee);
    x_ei     = addColorDimension(input.x_ei);
    y_ie     = addColorDimension(input.y_ie);
    state    = load('data/state_UpdateXY.mat');
    config   = state.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_calculate_xy_',instance,'.mat']);
end