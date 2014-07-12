function test_suite = test_get_excitation_and_inhibition
%TEST_ADD_PADDING Test suite for model.test_get_excitation_and_inhibition()
  initTestSuite;
end

function test_x_ee_3D_t01_i01
    assert_x_ee('3D_t01_i01', 0, 0);
end
function test_x_ee_3D_t01_i01_fft
    assert_x_ee('3D_t01_i01', 1, 0);
end

function test_x_ei_3D_t01_i01
    assert_x_ei('3D_t01_i01', 0, 0);
end
function test_x_ei_3D_t01_i01_fft
    assert_x_ei('3D_t01_i01', 1, 0);
end

function test_y_ie_3D_t01_i01
    assert_y_ie('3D_t01_i01', 0, 0);
end
function test_y_ie_3D_t01_i01_fft
    assert_y_ie('3D_t01_i01', 1, 0);
end

function test_x_ee_3D_t01_i02
    assert_x_ee('3D_t01_i02', 0, 0);
end
function test_x_ee_3D_t01_i02_fft
    assert_x_ee('3D_t01_i02', 1, 0);
end

function test_x_ei_3D_t01_i02
    assert_x_ei('3D_t01_i02', 0, 0);
end
function test_x_ei_3D_t01_i02_fft
    assert_x_ei('3D_t01_i02', 1, 0);
end

function test_y_ie_3D_t01_i02
    assert_y_ie('3D_t01_i02', 0, 0);
end
function test_y_ie_3D_t01_i02_fft
    assert_y_ie('3D_t01_i02', 1, 0);
end

function test_x_ee_3D_t01_i03
    assert_x_ee('3D_t01_i03', 0, 0);
end
function test_x_ee_3D_t01_i03_fft
    assert_x_ee('3D_t01_i03', 1, 0);
end

function test_x_ei_3D_t01_i03
    assert_x_ei('3D_t01_i03', 0, 0);
end
function test_x_ei_3D_t01_i03_fft
    assert_x_ei('3D_t01_i03', 1, 0);
end

function test_y_ie_3D_t01_i03
    assert_y_ie('3D_t01_i03', 0, 0);
end
function test_y_ie_3D_t01_i03_fft
    assert_y_ie('3D_t01_i03', 1, 0);
end

function test_x_ee_3D_t04_i01
    assert_x_ee('3D_t04_i01', 0, 0);
end
function test_x_ee_3D_t04_i01_fft
    assert_x_ee('3D_t04_i01', 1, 0);
end

function test_x_ei_3D_t04_i01
    assert_x_ei('3D_t04_i01', 0, 0);
end
function test_x_ei_3D_t04_i01_fft
    assert_x_ei('3D_t04_i01', 1, 0);
end

function test_y_ie_3D_t04_i01
    assert_y_ie('3D_t04_i01', 0, 0);
end
function test_y_ie_3D_t04_i01_fft
    assert_y_ie('3D_t04_i01', 1, 0);
end

%% ASSERTIONS

% Assert that, given known input, the output is as expected

function assert_x_ee(instance, use_fft, channel_interaction)
    config = get_config(use_fft, channel_interaction);
    [gx_padded, gy_padded, JW, interactions] = get_input(instance);
    [x_ee, ~, ~] = model.utils.get_excitation_and_inhibition(gx_padded, gy_padded, JW, interactions, config);
    expected = get_expected(instance);
    assertEqualData(x_ee, expected.x_ee);
end

function assert_x_ei(instance, use_fft, channel_interaction)
    config = get_config(use_fft, channel_interaction);
    [gx_padded, gy_padded, JW, interactions] = get_input(instance);
    [~, x_ei, ~] = model.utils.get_excitation_and_inhibition(gx_padded, gy_padded, JW, interactions, config);
    expected = get_expected(instance);
    assertEqualData(x_ei, expected.x_ei);
end

function assert_y_ie(instance, use_fft, channel_interaction)
    config = get_config(use_fft, channel_interaction);
    [gx_padded, gy_padded, JW, interactions] = get_input(instance);
    [~, ~, y_ie] = model.utils.get_excitation_and_inhibition(gx_padded, gy_padded, JW, interactions, config);
    expected = get_expected(instance);
    assertEqualData(y_ie, expected.y_ie);
end

%% TEST UTILITIES

function config = get_config(use_fft, channel_interaction)
    saved = load('data/input/config_40x40x3.mat');
    config = saved.config;
    config.compute.use_fft = use_fft;
    config.zli.channel_interaction = channel_interaction;
end

function [gx_padded, gy_padded, JW, interactions] = get_input(instance)
    input        = load(['data/input/get_excitation_inhibition_',instance,'.mat']);
    gx_padded    = input.gx_padded;
    gy_padded    = input.gy_padded;
    JW           = input.JW;
    interactions = input.interactions;
end

function expected = get_expected(instance)
    expected = load(['data/expected/get_excitation_inhibition_',instance,'.mat']);
end