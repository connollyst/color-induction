function test_suite = test_apply_model
%Test suite for model.apply()
  initTestSuite;
end

%% 1D TESTS: channel interactions should not affect the output

function test_1D_1_without_channel_interactions
    assert_apply_model(1, false)
end

function test_1D_2_without_channel_interactions
    assert_apply_model(2, false)
end

function test_1D_3_without_channel_interactions
    assert_apply_model(3, false)
end

function test_1D_1_with_channel_interactions
    assert_apply_model(1, true)
end

function test_1D_2_with_channel_interactions
    assert_apply_model(2, true)
end

function test_1D_3_with_channel_interactions
    assert_apply_model(3, true)
end

%% 3D TESTS

function test_3D_without_interactions
    % Given
    I = imread('peppers.png');
    I_in = imresize(I, 0.15);
    config = configurations.default();
    config.display.logging                = false;
    config.display.plot                   = false;
    config.image.type                     = 'bw';
    config.wave.n_scales                  = 2;
    config.zli.n_membr                    = 3;
    config.zli.n_iter                     = 3;
    config.zli.interaction.orient.enabled = false;
    config.zli.interaction.scale.enabled  = false;
    config.zli.interaction.color.enabled  = false;
    I_out = model.apply(I_in, config);
    assertEqualData(I_out, im2double(I_in))
end

function test_separate_and_opponent_ON_OFF_without_channel_interactions
% Processing the ON & OFF channels 'separate' should give the exact same
% output as processing them as 'opponent', if channel interactions are
% disabled.
    % Given
    I = imread('peppers.png');
    I = imresize(I, 0.15);
    I = I(:,:,1);
    config = configurations.default();
    config.display.logging               = false;
    config.display.plot                  = false;
    config.image.type                    = 'bw';
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 3;
    config.zli.n_iter                    = 3;
    config.zli.interaction.color.enabled = true;
    configA = config;
    configB = config;
    configA.zli.ON_OFF                   = 'separate';
    configB.zli.ON_OFF                   = 'opponent';
    % When
    separate = model.apply(I, configA);
    opponent = model.apply(I, configB);
    % Then
    assertEqualData(separate, opponent)
end

function test_3D
% Note: the three 1D channels processed in other tests are combined here.
%       If those tests pass, this should also.
    assert_apply_model(1:3, 0)
end


%% ASSERTIONS

function assert_apply_model(channels, channel_interaction)
    % Given
    config   = get_config(channel_interaction);
    I        = get_input(channels);
    % When
    actual   = model.apply(I, config);
    % Then
    expected = get_expected(channels);
    assertEqualData(actual, expected)
end

%% TEST UTILITIES

function config = get_config(channel_interaction)
    config = configurations.default();
    config.zli.n_membr = 3;
    config.zli.config.zli.add_neural_noise = 0;
    config.zli.interaction.color.enabled = channel_interaction;
    config.zli.interaction.color.weight  = 0;   % TODO what's a good weight?
    % Infer number of scales
    config.wave.n_scales = 2;
    % Use the orientation wavelet decompositon
    config.wave.transform = 'DWD_orient_undecimated';
    % 
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