function test_suite = test_NCZLd
%Test suite for model.process.NCZLd()
  initTestSuite;
end

function test_NCZLd_1D_1
    assert_NCZLd('1D_1')
end

function test_NCZLd_1D_2
    assert_NCZLd('1D_2')
end

function test_NCZLd_1D_3
    assert_NCZLd('1D_3')
end

function test_NCZLd_3D_1
% Note: the 3 1D channels processed in other tests are combined here. If
%       those tests pass, this should also.
    assert_NCZLd('3D_1')
end

%% ASSERTIONS

function assert_NCZLd(instance)
    [I, config] = get_input(instance);
    actual   = model.process.NCZLd(I, config);
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

function config = get_config()
    saved  = load('data/input/NCZLd_config.mat');
    config = saved.config;
end

function [I, config] = get_input(instance)
    input   = load(['data/input/NCZLd_',instance,'.mat']);
    I       = input.I;
    config  = get_config();
end

function expected = get_expected(instance)
    expected = load(['data/expected/NCZLd_',instance,'.mat']);
    expected = expected.O;
end