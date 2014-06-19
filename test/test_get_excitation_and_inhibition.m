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

function test_x_ee_02
    assert_x_ee('02');
end

function test_x_ei_02
    assert_x_ei('02');
end

function test_y_ie_02
    assert_y_ie('02');
end

function test_x_ee_03
    assert_x_ee('03');
end

function test_x_ei_03
    assert_x_ei('03');
end

function test_y_ie_03
    assert_y_ie('03');
end

function test_x_ee_09
    assert_x_ee('09');
end

function test_x_ei_09
    assert_x_ei('09');
end

function test_y_ie_09
    assert_y_ie('09');
end

function test_x_ee_reproducable_01
    assert_x_ee_reproducable('01');
end

function test_x_ei_reproducable_01
    assert_x_ei_reproducable('01');
end

function test_y_ie_reproducable_01
    assert_y_ie_reproducable('01');
end

function test_x_ee_reproducable_02
    assert_x_ee_reproducable('02');
end

function test_x_ei_reproducable_02
    assert_x_ei_reproducable('02');
end

function test_y_ie_reproducable_02
    assert_y_ie_reproducable('02');
end

function test_x_ee_reproducable_03
    assert_x_ee_reproducable('03');
end

function test_x_ei_reproducable_03
    assert_x_ei_reproducable('03');
end

function test_y_ie_reproducable_03
    assert_y_ie_reproducable('03');
end

function test_x_ee_reproducable_09
    assert_x_ee_reproducable('09');
end

function test_x_ei_reproducable_09
    assert_x_ei_reproducable('09');
end

function test_y_ie_reproducable_09
    assert_y_ie_reproducable('09');
end

%% ASSERTIONS

% Assert that, given known input, the output is as expected

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

% Assert that, given the same input, the output is always the same..

function assert_x_ee_reproducable(instance)
    [newgx, newgy, Delta, JW, interactions, config] = get_input(instance);
    [x_ee1, ~, ~] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    [x_ee2, ~, ~] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    assertEqual(x_ee1, x_ee2);
end

function assert_x_ei_reproducable(instance)
    [newgx, newgy, Delta, JW, interactions, config] = get_input(instance);
    [~, x_ei1, ~] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    [~, x_ei2, ~] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    assertEqual(x_ei1, x_ei2);
end

function assert_y_ie_reproducable(instance)
    [newgx, newgy, Delta, JW, interactions, config] = get_input(instance);
    [~, ~, y_ie1] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    [~, ~, y_ie2] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    assertEqual(y_ie1, y_ie2);
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