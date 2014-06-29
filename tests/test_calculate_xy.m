function test_suite = test_calculate_xy
%TEST_ADD_PADDING Test suite for model.calculate_xy()
  initTestSuite;
end

function test_calculate_x_3D_t01_i01
    assert_x('3D_t01_i01')
end

function test_calculate_y_3D_t01_i01
    assert_y('3D_t01_i01')
end

function test_calculate_x_3D_t01_i02
    assert_x('3D_t01_i02')
end

function test_calculate_y_3D_t01_i02
    assert_y('3D_t01_i02')
end

function test_calculate_x_3D_t01_i03
    assert_x('3D_t01_i03')
end

function test_calculate_y_3D_t01_i03
    assert_y('3D_t01_i03')
end

function test_calculate_x_3D_t04_i01
    assert_x('3D_t04_i01')
end

function test_calculate_y_3D_t04_i01
    assert_y('3D_t04_i01')
end

%% ASSERTIONS

function assert_x(instance)
    [tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config] = get_input(instance);
    [x_out, ~] = model.calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    expected = get_expected(instance);
    assertEqualData(x_out, expected.x);
end

function assert_y(instance)
    [tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config] = get_input(instance);
    [~, y_out] = model.calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    expected = get_expected(instance);
    assertEqualData(y_out, expected.y);
end

%% TEST UTILITIES

function [tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config] = get_input(instance)
    input    = load(['data/input/calculate_xy_',instance,'.mat']);
    tIitheta = input.tIitheta;
    I_norm   = input.I_norm;
    x        = input.x;
    y        = input.y;
    x_ee     = input.x_ee;
    x_ei     = input.x_ei;
    y_ie     = input.y_ie;
    config   = get_config();
end

function config = get_config()
    saved = load('data/input/config_40x40x3.mat');
    config = saved.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected/calculate_xy_',instance,'.mat']);
end
