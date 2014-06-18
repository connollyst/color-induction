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
    [x_out, ~]       = calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    expected = get_expected(instance);
    assertEqualMatricies(x_out, expected.x);
end

function assert_y_out(instance)
    [tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config] = get_input(instance);
    [~, y_out]       = calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    expected = get_expected(instance);
    assertEqualMatricies(y_out, expected.y);
end

%% TEST UTILITIES

function [tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config] = get_input(instance)
    input    = load(['data/input_to_normalize_output_',instance,'.mat']);
    tIitheta = addColorDimension(input.Iitheta{1}); % TODO get correct frame
    I_norm   = addColorDimension(input.I_norm);
    x        = addColorDimension(input.x);
    y        = addColorDimension(input.y);
    x_ee     = addColorDimension(input.x_ee);
    x_ei     = addColorDimension(input.x_ei);
    y_ie     = addColorDimension(input.x_ie);
    state    = load('data/state_UpdateXY.mat');
    config   = state.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_normalize_output_',instance,'.mat']);
end