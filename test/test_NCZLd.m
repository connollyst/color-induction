function test_suite = test_NCZLd
%Test suite for model.process.NCZLd()
  initTestSuite;
end

function test_NCZLd_1D
    assert_NCZLd('1D')
end

function test_NCZLd_3D
    assert_NCZLd('3D')
end

%% ASSERTIONS

function assert_NCZLd(instance)
    [I, config] = get_input(instance);
    actual      = model.process.NCZLd(I, config);
    expected    = get_expected(instance);
    assertEqual(actual, expected);
end

%% TEST UTILITIES

function [I, config] = get_input(instance)
    input   = load(['data/input_to_NCZLd_',instance,'.mat']);
    I{1}    = input.img;
    state   = load('data/state_UpdateXY.mat');
    config  = state.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_NCZLd_',instance,'.mat']);
    expected = expected.img_out;
end