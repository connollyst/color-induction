function test_suite = test_apply_model
%Test suite for model.apply()
  initTestSuite;
end

% 1D TESTS: channel interactions should not affect the output

function test_apply_model_1D_1_without_channel_interactions
    assert_apply_model(1, 0)
end

function test_apply_model_1D_2_without_channel_interactions
    assert_apply_model(2, 0)
end

function test_apply_model_1D_3_without_channel_interactions
    assert_apply_model(3, 0)
end

function test_apply_model_1D_1_with_channel_interactions
    assert_apply_model(1, 1)
end

function test_apply_model_1D_2_with_channel_interactions
    assert_apply_model(2, 1)
end

function test_apply_model_1D_3_with_channel_interactions
    assert_apply_model(3, 1)
end

function test_separate_and_opponent_ON_OFF_without_channel_interactions
% Processing the ON & OFF channels 'separate' should give the exact same
% output as processing them as 'opponent', if channel interactions are
% disabled.
    I = imread('peppers.png');
    I = imresize(I, 0.15);
    I = I(:,:,1);
    config = configurations.default();
    config.display.logging               = 0;
    config.display.plot                  = 0;
    config.image.type                    = 'bw';
    config.wave.n_scales                 = 2;
    config.zli.n_membr                   = 3;
    config.zli.n_iter                    = 3;
    config.zli.interaction.color.enabled = 0;
    config.zli.interaction.color.scheme  = 'default';
    config.zli.ON_OFF                    = 'separate';
    separate = model.apply(I, config);
    config.zli.interaction.color.scheme  = 'opponent';
    config.zli.ON_OFF                    = 'opponent';
    opponent = model.apply(I, config);
    assertDimensionsEqual(separate, opponent)
end

% 3D TESTS

function test_apply_model_3D_1
% Note: the 3 1D channels processed in other tests are combined here. If
%       those tests pass, this should also.
    assert_apply_model(1:3, 0)
end


%% ASSERTIONS

function assert_apply_model(channels, channel_interaction)
    config   = get_config(channel_interaction);
    I        = get_input(channels);
    actual   = model.apply(I, config);
    expected = get_expected(channels);
    assertDimensionsEqual(actual, expected)
end

function assertDimensionsEqual(actual, expected)
    assertEqual(size(actual), size(expected));
    for i=1:size(actual,3)
        assertEqual(actual(:,:,i), expected(:,:,i), ...
            ['Results differ in dimension ',num2str(i),' (at least)']);
    end
end


%% TEST UTILITIES

function config = get_config(channel_interaction)
    config = configurations.default();
    config.zli.n_membr = 3;
    config.zli.config.zli.add_neural_noise = 0;
    config.zli.interaction.color.enabled = channel_interaction;
    % Infer number of scales
    config.wave.n_scales = 2;
    % Use the orientation wavelet decompositon
    config.wave.transform = 'DWD_orient_undecimated';
    % 
    config.image.type = 'lab';
    % Disable all data display
    config.display.logging = 0;
    config.display.plot    = 0;
end

function I = get_input(channels)
    input  = load('data/input/apply_model_3D.mat');
    I      = input.I(:,:,channels);
end

function expected = get_expected(channels)
    expected = load('data/expected/apply_model_3D.mat');
    expected = expected.O(:,:,channels);
end