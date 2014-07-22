function test_suite = test_regression
% Ensure backward compatability with the original model by comparing the
% output with that obtained from the original model.
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
    expected = get_expected(channels);
    assertEqualData(actual, expected)
end

%% TEST UTILITIES

function config = get_config()
    config = configurations.default();
    config.zli.n_membr = 3;
    config.zli.config.zli.add_neural_noise = false;
    config.zli.interaction.color.enabled   = false;
    % Infer number of scales
    config.wave.n_scales = 2;
    % Use the orientation wavelet decompositon
    config.wave.transform = 'DWD_orient_undecimated';
    % The data is already in L*a*b format
    config.image.type = 'lab';
    % Disable all data display
    config.display.logging = false;
    config.display.plot    = false;
end

function I = get_input(channels)
    input  = load('data/input/apply_model_3D.mat');
    I      = input.I(:,:,channels);
end

function expected = get_expected(channels)
    expected = load('data/expected/apply_model_3D.mat');
    expected = expected.O(:,:,channels);
end