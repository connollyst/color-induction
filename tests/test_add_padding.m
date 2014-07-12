function test_suite = test_add_padding
%TEST_ADD_PADDING Test suite for model.add_padding()
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
    [x, y, interactions, config] = get_input(instance);
    [gx_padded, ~] = utils.padding.add(x, y, interactions, config);
    expected = get_output(instance);
    assertEqualData(gx_padded, expected.newgx_toroidal_x);
end

function assert_gy_padded(instance)
    [x, y, interactions, config] = get_input(instance);
    [~, gy_padded] = utils.padding.add(x, y, interactions, config);
    expected = get_output(instance);
    assertEqualData(gy_padded, expected.newgy_toroidal_y);
end

%% TEST UTILITIES

function [x, y, interactions, config] = get_input(instance)
    input        = load(['data/input/add_padding_',instance,'.mat']);
    x            = input.x;
    y            = input.y;
    Delta        = input.Delta;
    interactions = input.interactions;
    config       = input.config;
    interactions.n_scale_interactions = 4; % TODO update config
    config.wave.scale_deltas = Delta;      % TODO use common config
end

function output = get_output(instance)
    output = load(['data/expected/add_padding_',instance,'.mat']);
end