function test_suite = test_add_padding
%TEST_ADD_PADDING Test suite for model.add_padding()
  initTestSuite;
end

function test_padded_newgx_toroidal_x_3D_t01_i01
    assert_padded_newgx_toroidal_x('3D_t01_i01');
end

function test_padded_newgy_toroidal_y_3D_t01_i01
    assert_padded_newgy_toroidal_y('3D_t01_i01');
end

function test_padded_restr_newgx_toroidal_x_3D_t01_i01
    assert_padded_restr_newgx_toroidal_x('3D_t01_i01')
end

function test_padded_restr_newgy_toroidal_y_3D_t01_i01
    assert_padded_restr_newgy_toroidal_y('3D_t01_i01')
end

function test_padded_newgx_toroidal_x_3D_t01_i02
    assert_padded_newgx_toroidal_x('3D_t01_i02');
end

function test_padded_newgy_toroidal_y_3D_t01_i02
    assert_padded_newgy_toroidal_y('3D_t01_i02');
end

function test_padded_restr_newgx_toroidal_x_3D_t01_i02
    assert_padded_restr_newgx_toroidal_x('3D_t01_i02')
end

function test_padded_restr_newgy_toroidal_y_3D_t01_i02
    assert_padded_restr_newgy_toroidal_y('3D_t01_i02')
end

function test_padded_newgx_toroidal_x_3D_t01_i03
    assert_padded_newgx_toroidal_x('3D_t01_i03');
end

function test_padded_newgy_toroidal_y_3D_t01_i03
    assert_padded_newgy_toroidal_y('3D_t01_i03');
end

function test_padded_restr_newgx_toroidal_x_3D_t01_i03
    assert_padded_restr_newgx_toroidal_x('3D_t01_i03')
end

function test_padded_restr_newgy_toroidal_y_3D_t01_i03
    assert_padded_restr_newgy_toroidal_y('3D_t01_i03')
end

function test_padded_newgx_toroidal_x_3D_t04_i01
    assert_padded_newgx_toroidal_x('3D_t04_i01');
end

function test_padded_newgy_toroidal_y_3D_t04_i01
    assert_padded_newgy_toroidal_y('3D_t04_i01');
end

function test_padded_restr_newgx_toroidal_x_3D_t04_i01
    assert_padded_restr_newgx_toroidal_x('3D_t04_i01')
end

function test_padded_restr_newgy_toroidal_y_3D_t04_i01
    assert_padded_restr_newgy_toroidal_y('3D_t04_i01')
end
%% ASSERTIONS

function assert_padded_newgx_toroidal_x(instance)
    [x, y, Delta, interactions, config] = get_input(instance);
    [newgx_toroidal_x, ~, ~, ~] = model.add_padding(x, y, Delta, interactions, config);
    expected = get_output(instance);
    assertEqualCells(newgx_toroidal_x, expected.newgx_toroidal_x);
end

function assert_padded_newgy_toroidal_y(instance)
    [x, y, Delta, interactions, config] = get_input(instance);
    [~, newgy_toroidal_y, ~, ~] = model.add_padding(x, y, Delta, interactions, config);
    expected = get_output(instance);
    assertEqualCells(newgy_toroidal_y, expected.newgy_toroidal_y);
end

function assert_padded_restr_newgx_toroidal_x(instance)
    [x, y, Delta, interactions, config] = get_input(instance);
    [~, ~, restr_newgx_toroidal_x, ~] = model.add_padding(x, y, Delta, interactions, config);
    expected = get_output(instance);
    assertEqual(restr_newgx_toroidal_x, expected.restr_newgx_toroidal_x);
end

function assert_padded_restr_newgy_toroidal_y(instance)
    [x, y, Delta, interactions, config] = get_input(instance);
    [~, ~, ~, restr_newgy_toroidal_y] = model.add_padding(x, y, Delta, interactions, config);
    expected = get_output(instance);
    assertEqual(restr_newgy_toroidal_y, expected.restr_newgy_toroidal_y);
end

%% TEST UTILITIES

function [x, y, Delta, interactions, config] = get_input(instance)
    input        = load(['data/input/add_padding_',instance,'.mat']);
    x            = input.x;
    y            = input.y;
    Delta        = input.Delta;
    interactions = input.interactions;
    config       = input.config;
end

function output = get_output(instance)
    output = load(['data/expected/add_padding_',instance,'.mat']);
end