function test_suite = test_get_excitation_and_inhibition
%TEST_ADD_PADDING Test suite for model.test_get_excitation_and_inhibition()
  initTestSuite;
end

function test_x_ee_01
    assert_x_ee('01');
end

function test_x_ei_01
    assert_x_ei('01');
end

function test_y_ie_01
    assert_y_ie('01');
end

%% ASSERTIONS

function assert_x_ee(instance)
    [newgx, newgy, Delta, JW, interactions, config] = get_input(instance);
    [x_ee, ~, ~] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    expected = get_expected(instance);
    assertEqualMatrices(x_ee, expected.x_ee);
end

function assert_x_ei(instance)
    [newgx, newgy, Delta, JW, interactions, config] = get_input(instance);
    [~, x_ei, ~] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    expected = get_expected(instance);
    assertEqualMatrices(x_ei, expected.x_ei);
end

function assert_y_ie(instance)
    [newgx, newgy, Delta, JW, interactions, config] = get_input(instance);
    [~, ~, y_ie] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    expected = get_expected(instance);
    assertEqualMatrices(y_ie, expected.y_ie);
end

%% TEST UTILITIES

function [newgx, newgy, Delta, JW, interactions, config] = get_input(instance)
    input        = load(['data/input_to_get_excitation_inhibition_',instance,'.mat']);
    newgx        = addColorDimension(input.newgx_toroidal_x);
    newgy        = addColorDimension(input.restr_newgy_toroidal_y);
    state        = load('data/state_UpdateXY.mat');
    Delta        = state.Delta;
    JW           = state.JW;
    interactions = state.interactions;
    config       = state.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_get_excitation_inhibition_',instance,'.mat']);
end