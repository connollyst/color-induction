function test_suite = test_apply_model
%Test suite for model.apply()
  initTestSuite;
end

% 1D TESTS: channel interactions should not affect the output

function test_apply_model_1D_1_without_channel_interactions
    assert_apply_model('1D_1', 0)
end

function test_apply_model_1D_2_without_channel_interactions
    assert_apply_model('1D_2', 0)
end

function test_apply_model_1D_3_without_channel_interactions
    assert_apply_model('1D_3', 0)
end

function test_apply_model_1D_1_with_channel_interactions
    assert_apply_model('1D_1', 1)
end

function test_apply_model_1D_2_with_channel_interactions
    assert_apply_model('1D_2', 1)
end

function test_apply_model_1D_3_with_channel_interactions
    assert_apply_model('1D_3', 1)
end

function test_separate_and_opponent_ON_OFF_without_channel_interactions
% Processing the ON & OFF channels 'separate' should give the exact same
% output as processing them as 'opponent', if channel interactions are
% disabled.
    I = imread('peppers.png');
    I = imresize(I, 0.15);
    I = I(:,:,1);
    config = configurations.default();
    config.display.logging          = 0;
    config.display.plot             = 0;
    config.image.type               = 'bw';
    config.wave.n_scales            = 2;
    config.zli.n_membr              = 3;
    config.zli.n_iter               = 3;
    config.zli.channel_interactions = 0;
    config.zli.ON_OFF               = 'separate';
    separate = model.apply(I, config);
    config.zli.ON_OFF               = 'opponent';
    opponent = model.apply(I, config);
    assertDimensionsEqual(separate, opponent)
end

% 3D TESTS

function test_apply_model_3D_1
% Note: the 3 1D channels processed in other tests are combined here. If
%       those tests pass, this should also.
    assert_apply_model('3D_1', 0)
end


%% ASSERTIONS

function assert_apply_model(instance, channel_interaction)
    [I, config] = get_input(instance, channel_interaction);
    actual   = model.apply(I, config);
    expected = get_expected(instance);
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

function [I, config] = get_input(instance, channel_interaction)
    input  = load(['data/input/apply_model_',instance,'.mat']);
    I      = input.I;
    config = configurations.default();
    config.zli.n_membr = 3;
    config.zli.config.zli.add_neural_noise = 0;
    config.zli.channel_interaction = channel_interaction;
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

function expected = get_expected(instance)
    expected = load(['data/expected/apply_model_',instance,'.mat']);
    expected = expected.O;
end