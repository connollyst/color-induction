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

function assert_x_ee(instance, use_fft, color_interaction)
    config = get_config(use_fft, color_interaction);
    [gx_padded, gy_padded, interactions] = get_input(instance, config);
    [x_ee, ~, ~] = model.terms.get_excitation_and_inhibition(gx_padded, gy_padded, interactions, config);
    expected = get_expected(instance);
    assertEqualData(x_ee, expected.x_ee);
end

function assert_x_ei(instance, use_fft, color_interaction)
    config = get_config(use_fft, color_interaction);
    [gx_padded, gy_padded, interactions] = get_input(instance, config);
    [~, x_ei, ~] = model.terms.get_excitation_and_inhibition(gx_padded, gy_padded, interactions, config);
    expected = get_expected(instance);
    assertEqualData(x_ei, expected.x_ei);
end

function assert_y_ie(instance, use_fft, color_interaction)
    config = get_config(use_fft, color_interaction);
    [gx_padded, gy_padded, interactions] = get_input(instance, config);
    [~, ~, y_ie] = model.terms.get_excitation_and_inhibition(gx_padded, gy_padded, interactions, config);
    expected = get_expected(instance);
    assertEqualData(y_ie, expected.y_ie);
end

%% TEST UTILITIES

function config = get_config(use_fft, color_interaction)
    config = get_test_config(40, 40, 3, 2);
    config.compute.use_fft = use_fft;
    config.zli.interaction.color.enabled = color_interaction;
end

function [gx_padded, gy_padded, interactions] = get_input(instance, config)
    input        = load(['data/input/get_excitation_inhibition_',instance,'.mat']);
    gx_padded    = input.gx_padded;
    gy_padded    = input.gy_padded;
    interactions = model.terms.get_interactions(config);
end

function expected = get_expected(instance)
    expected = load(['data/expected/get_excitation_inhibition_',instance,'.mat']);
end