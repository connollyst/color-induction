function test_suite = test_add
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
    [gx_padded, ~] = get_padded(instance);
    expected       = get_output(instance);
    assertEqualData(gx_padded, expected.newgx_toroidal_x);
end

function assert_gy_padded(instance)
    [~, gy_padded] = get_padded(instance);
    expected       = get_output(instance);
    assertEqualData(gy_padded, expected.newgy_toroidal_y);
end

function [gx_padded, gy_padded] = get_padded(instance)
    [x, y, interactions, config] = get_input(instance);
    [gx_padded, gy_padded] = model.data.padding.add(x, y, interactions, config);
end

%% TEST UTILITIES

function [x, y, interactions, config] = get_input(instance)
    input        = load(['data/input/add_padding_',instance,'.mat']);
    x            = input.x;
    y            = input.y;
    config       = get_test_config(40, 40, 3, 2);
    interactions = model.terms.get_interactions(config);
end

function output = get_output(instance)
    output = load(['data/expected/add_padding_',instance,'.mat']);
end