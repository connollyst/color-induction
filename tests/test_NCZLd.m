function test_suite = test_NCZLd
%Test suite for model.process.NCZLd()
  initTestSuite;
end

% 1D TESTS: channel interactions should not affect the output

function test_NCZLd_1D_1_without_channel_interactions
    assert_NCZLd('1D_1', 0)
end

function test_NCZLd_1D_2_without_channel_interactions
    assert_NCZLd('1D_2', 0)
end

function test_NCZLd_1D_3_without_channel_interactions
    assert_NCZLd('1D_3', 0)
end

function test_NCZLd_1D_1_with_channel_interactions
    assert_NCZLd('1D_1', 1)
end

function test_NCZLd_1D_2_with_channel_interactions
    assert_NCZLd('1D_2', 1)
end

function test_NCZLd_1D_3_with_channel_interactions
    assert_NCZLd('1D_3', 1)
end

% 3D TESTS

function test_NCZLd_3D_1
% Note: the 3 1D channels processed in other tests are combined here. If
%       those tests pass, this should also.
    assert_NCZLd('3D_1', 0)
end


%% ASSERTIONS

function assert_NCZLd(instance, channel_interaction)
    [I, config] = get_input(instance, channel_interaction);
    actual   = model.NCZLd(I, config);
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

function config = get_config(channel_interaction)
    saved  = load('data/input/NCZLd_config.mat');
    config = saved.config;
    config.zli.channel_interaction = channel_interaction;
end

function [I, config] = get_input(instance, channel_interaction)
    input   = load(['data/input/NCZLd_',instance,'.mat']);
    I       = input.I;
    config  = get_config(channel_interaction);
end

function expected = get_expected(instance)
    expected = load(['data/expected/NCZLd_',instance,'.mat']);
    expected = expected.O;
end