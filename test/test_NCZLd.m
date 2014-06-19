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

function test_NCZLd_3D
% Note: the 3 1D channels processed in other tests are combined here. If
%       those tests pass, this should also.
    assert_NCZLd('3D')
end

%% ASSERTIONS

function assert_NCZLd(instance)
    [I, config] = get_input(instance);
    actual      = model.process.NCZLd(I, config);
    expected    = get_expected(instance);
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