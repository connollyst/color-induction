function test_suite = test_NCZLd_channel
%Test suite for model.process.NCZLd_channel_v*()
  initTestSuite;
end

function test_NCZLd_channel_1D_1
    assert_NCZLd_channel('1D_1')
end

function test_NCZLd_channel_1D_2
    assert_NCZLd_channel('1D_2')
end

function test_NCZLd_channel_1D_3
    assert_NCZLd_channel('1D_3')
end

function test_NCZLd_channel_3D_1
    assert_NCZLd_channel('3D_1')
end

%% ASSERTIONS

function assert_NCZLd_channel(instance)
    [I, config] = get_input(instance);
    expected    = get_expected(instance);
    actual      = model.process.NCZLd_channel_v1_0(I, config);
    assertEqual(actual, expected, 3);
end

%% TEST UTILITIES

function [I, config] = get_input(instance)
    input   = load(['data/input/NCZLd_channel_',instance,'.mat']);
    I       = input.I;
    config  = input.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected/NCZLd_channel_',instance,'.mat']);
    expected = expected.I_out;
end