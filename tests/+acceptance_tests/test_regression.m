function test_suite = test_regression
% Ensure backward compatability with the original model by comparing the
% output with that obtained from the original model.
% Note: due to a rounding difference between the original model and the
%       current model, we actually assert the output is exactly what is
%       expected from this model, and also assert that the output is
%       'almost' what is expected from the original model.
  initTestSuite;
end

function test_1D_1
    assert_apply_model(1)
end

function test_1D_2
    assert_apply_model(2)
end

function test_1D_3
    assert_apply_model(3)
end

function test_3D
    assert_apply_model(1:3)
end

%% ASSERTIONS

function assert_apply_model(channels)
    % Given
    config   = get_config();
    I        = get_input(channels);
    % When
    actual   = model.apply(I, config);
    % Then
    assertEqualData(actual,           get_expected_current(channels))
    assertElementsAlmostEqual(actual, get_expected_original(channels));
end

%% TEST UTILITIES

function config = get_config()
    config = configurations.default();
    % Configure the original algorithm parameters
    config.zli.interaction.color.enabled   = false;
    config.zli.config.zli.add_neural_noise = false;
    config.zli.ON_OFF      = 'separate';
    config.zli.n_membr     = 3;
    % Configure the wavelet decompositon
    config.wave.n_scales   = 2;
    config.wave.n_orients  = 3;
    config.wave.transform  = 'dwt';
    config.image.transform = 'rgb';
    % Disable all data display
    config.display.logging = false;
    config.display.plot    = false;
end

function I = get_input(channels)
    input  = load('data/input/apply_model_3D.mat');
    I      = input.I(:,:,channels);
end

function expected = get_expected_current(channels)
    expected = load('data/expected/regression_current.mat');
    expected = expected.O(:,:,channels);
end

function expected = get_expected_original(channels)
    expected = load('data/expected/regression_original.mat');
    expected = expected.O(:,:,channels);
end