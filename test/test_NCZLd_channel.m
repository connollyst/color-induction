function test_suite = test_NCZLd_channel
%Test suite for model.process.NCZLd_channel_v*()
  initTestSuite;
end

function test_NCZLd_channel_01
    assert_NCZLd_channel('01')
end

%% ASSERTIONS

function assert_NCZLd_channel(instance)
    [I, config] = get_input(instance);
    actual      = model.process.NCZLd_channel_v1_0(I, config);
    expected    = get_expected(instance);
    % Note: our expected output comes from the old model for now: we need
    %       to transform the data while asserting equality, for now.
    assertEqual(length(actual), size(expected, 3));
    for t=1:length(actual)
        nextActual   = actual{t};
        nextExpected = expected(:,:,t);
        assertEqual(nextActual, nextExpected);
    end
end

%% TEST UTILITIES

function [I, config] = get_input(instance)
    input   = load(['data/input_to_NCZLd_channel_',instance,'.mat']);
    I       = cell(1,1);
    I{1}    = input.img;
    state   = load('data/state_UpdateXY.mat');
    config  = state.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_NCZLd_channel_',instance,'.mat']);
    expected = expected.img_out;
end