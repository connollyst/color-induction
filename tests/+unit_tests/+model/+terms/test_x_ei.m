function test_suite = test_x_ei
  initTestSuite;
end

function test_x_ei_3D_t01_i01
    assert_x_ei('3D_t01_i01', 0, 0);
end
function test_x_ei_3D_t01_i01_fft
    assert_x_ei('3D_t01_i01', 1, 0);
end


function test_x_ei_3D_t01_i02
    assert_x_ei('3D_t01_i02', 0, 0);
end
function test_x_ei_3D_t01_i02_fft
    assert_x_ei('3D_t01_i02', 1, 0);
end


function test_x_ei_3D_t01_i03
    assert_x_ei('3D_t01_i03', 0, 0);
end
function test_x_ei_3D_t01_i03_fft
    assert_x_ei('3D_t01_i03', 1, 0);
end


function test_x_ei_3D_t04_i01
    assert_x_ei('3D_t04_i01', 0, 0);
end
function test_x_ei_3D_t04_i01_fft
    assert_x_ei('3D_t04_i01', 1, 0);
end

%% ASSERTIONS

% Assert that, given known input, the output is as expected

function assert_x_ei(instance, use_fft, color_interaction)
    [gy, interactions, config] = get_input(instance, use_fft, color_interaction);
    actual_x_ei                = model.terms.x_ei(gy, interactions, config);
    expected_x_ei              = get_expected(instance);
    assertEqualData(actual_x_ei, expected_x_ei);
end

%% TEST UTILITIES

function [gy, interactions, config] = get_input(instance, use_fft, color_interaction)
    input  = load(['data/input/update_xy_',instance,'.mat']);
    y      = input.y;
    gy     = model.terms.gy(y);
    config = regression_config(40, 40, 3, 2);
    config.compute.use_fft = use_fft;
    config.zli.interaction.color.enabled = color_interaction;
    interactions = model.terms.get_interactions(config);
end

function expected_x_ei = get_expected(instance)
    expected = load(['data/expected/get_excitation_inhibition_',instance,'.mat']);
    expected_x_ei = expected.x_ei;
end