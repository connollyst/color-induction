function test_suite = test_add_padding
%TEST_ADD_PADDING Run the test suites for model.add_padding()
  initTestSuite;
end

function test_padded_newgx_toroidal_x_01
    assert_padded_newgx_toroidal_x('01');
end

function test_padded_newgy_toroidal_y_01
    assert_padded_newgy_toroidal_y('01');
end

function test_padded_restr_newgx_toroidal_x_01
    assert_padded_restr_newgx_toroidal_x('01')
end

function test_padded_restr_newgy_toroidal_y_01
    assert_padded_restr_newgy_toroidal_y('01')
end

function test_padded_newgx_toroidal_x_02
    assert_padded_newgx_toroidal_x('02');
end

function test_padded_newgy_toroidal_y_02
    assert_padded_newgy_toroidal_y('02');
end

function test_padded_restr_newgx_toroidal_x_02
    assert_padded_restr_newgx_toroidal_x('02')
end

function test_padded_restr_newgy_toroidal_y_02
    assert_padded_restr_newgy_toroidal_y('02')
end

%% TEST UTILITIES

function [x, y, Delta, interactions, config] = get_input(instance)
    input        = load(['data/add_padding_input_',instance,'.mat']);
    x            = addColorDimension(input.x);
    y            = addColorDimension(input.y);
    Delta        = input.Delta;
    state        = load('data/UpdateXY_config_interactions.mat');
    interactions = state.interactions;
    config       = state.config;
end

function output = get_output(instance)
    output = load(['data/add_padding_output_',instance,'.mat']);
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
    assertEqualMatrix(restr_newgx_toroidal_x, expected.restr_newgx_toroidal_x);
end

function assert_padded_restr_newgy_toroidal_y(instance)
    [x, y, Delta, interactions, config] = get_input(instance);
    [~, ~, ~, restr_newgy_toroidal_y] = model.add_padding(x, y, Delta, interactions, config);
    expected = get_output(instance);
    assertEqualMatrix(restr_newgy_toroidal_y, expected.restr_newgy_toroidal_y);
end

function assertEqualCells(actual, expected)
    assertEqual(size(actual), size(expected));
    for i=1:length(actual)
        assertEqualMatrix(actual{i}, expected{i})
    end
end

function assertEqualMatrix(actual, expected)
    expected = addColorDimension(expected);
    assertEqual(actual, expected);
end

function O = addColorDimension(I)
    c = size(I, 1);
    r = size(I, 2);
    s = size(I, 3);
    o = size(I, 4);
    O = zeros(c, r, 1, s, o);
    O(:,:,1,:,:) = I;
end