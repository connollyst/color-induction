function test_suite = test_get_excitation_and_inhibition
%TEST_ADD_PADDING Test suite for model.test_get_excitation_and_inhibition()
  initTestSuite;
end

function test_x_ee_3D_t01_i01
    assert_x_ee('3D_t01_i01');
end

function test_x_ei_3D_t01_i01
    assert_x_ei('3D_t01_i01');
end

function test_y_ie_3D_t01_i01
    assert_y_ie('3D_t01_i01');
end

function test_x_ee_3D_t01_i02
    assert_x_ee('3D_t01_i02');
end

function test_x_ei_3D_t01_i02
    assert_x_ei('3D_t01_i02');
end

function test_y_ie_3D_t01_i02
    assert_y_ie('3D_t01_i02');
end

function test_x_ee_3D_t01_i03
    assert_x_ee('3D_t01_i03');
end

function test_x_ei_3D_t01_i03
    assert_x_ei('3D_t01_i03');
end

function test_y_ie_3D_t01_i03
    assert_y_ie('3D_t01_i03');
end

function test_x_ee_3D_t04_i01
    assert_x_ee('3D_t04_i01');
end

function test_x_ei_3D_t04_i01
    assert_x_ei('3D_t04_i01');
end

function test_y_ie_3D_t04_i01
    assert_y_ie('3D_t04_i01');
end

%% ASSERTIONS

% Assert that, given known input, the output is as expected

function assert_x_ee(instance)
    [newgx, newgy, Delta, JW, interactions, config] = get_input(instance);
    [x_ee, ~, ~] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    expected = get_expected(instance);
    assertEqualData(x_ee, expected.x_ee);
end

function assert_x_ei(instance)
    [newgx, newgy, Delta, JW, interactions, config] = get_input(instance);
    [~, x_ei, ~] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    expected = get_expected(instance);
    assertEqualData(x_ei, expected.x_ei);
end

function assert_y_ie(instance)
    [newgx, newgy, Delta, JW, interactions, config] = get_input(instance);
    [~, ~, y_ie] = model.get_excitation_and_inhibition(newgx, newgy, Delta, JW, interactions, config);
    expected = get_expected(instance);
    assertEqualData(y_ie, expected.y_ie);
end

%% TEST UTILITIES

function [newgx, newgy, Delta, JW, interactions, config] = get_input(instance)
    input        = load(['data/input/get_excitation_inhibition_',instance,'.mat']);
    newgx        = input.newgx_toroidal_x;
    newgy        = input.restr_newgy_toroidal_y;
    Delta        = input.Delta;
    JW           = input.JW;
    interactions = input.interactions;
    config       = input.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected/get_excitation_inhibition_',instance,'.mat']);
end