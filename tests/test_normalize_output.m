function test_suite = test_normalize_output
%TEST_ADD_PADDING Test suite for model.normalize_output()
  initTestSuite;
end

function test_I_norm_3D_t01_i01
    assert_I_norm('3D_t01_i01')
end

function test_I_norm_3D_t01_i02
    assert_I_norm('3D_t01_i02')
end

function test_I_norm_3D_t01_i03
    assert_I_norm('3D_t01_i03')
end

function test_I_norm_3D_t04_i01
    assert_I_norm('3D_t04_i01')
end

%% ASSERTIONS

function assert_I_norm(instance)
    % TODO get input
    config = get_config();
    [norm_mask, newgx_toroidal_x, interactions] = get_input(instance);
    I_norm   = model.utils.normalize_output(norm_mask, newgx_toroidal_x, interactions, config);
    expected = get_expected(instance);
    assertEqualData(I_norm, expected.I_norm);
end

%% TEST UTILITIES

function config = get_config()
    saved = load('data/input/config_40x40x3.mat');
    config = saved.config;
end

function [norm_mask, newgx_toroidal_x, interactions] = get_input(instance)
    input            = load(['data/input/normalize_output_',instance,'.mat']);
    newgx_toroidal_x = input.newgx_toroidal_x;
    norm_mask        = input.norm_mask;
    interactions     = input.interactions;
end

function expected = get_expected(instance)
    expected = load(['data/expected/normalize_output_',instance,'.mat']);
end