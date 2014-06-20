function test_suite = test_NCZLd_channel_ON_OFF
%Test suite for model.process.NCZLd_channel_ON_OFF_v*()
  initTestSuite;
end

function test_NCZLd_channel_ON_OFF_3D_01
    assert_NCZLd_channel_ON_OFF('3D_1')
end

%% ASSERTIONS

function assert_NCZLd_channel_ON_OFF(instance)
    [Iitheta, config] = get_input(instance);
    expected = get_expected(instance);
    actual   = model.process.NCZLd_channel_ON_OFF_v1_1(Iitheta, config);
    assertEqualCells(actual, expected, config);
end

%% TEST UTILITIES

function [Iitheta, config] = get_input(instance)
    input   = load(['data/input/NCZLd_channel_ON_OFF_',instance,'.mat']);
    Iitheta = input.Iitheta;
    config  = input.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected/NCZLd_channel_ON_OFF_',instance,'.mat']);
    expected = expected.Iitheta_final;
end