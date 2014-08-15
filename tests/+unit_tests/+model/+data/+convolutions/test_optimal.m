function test_suite = test_optimal
  initTestSuite;
end

function test_optimal_01
% 4D input & output
    assert_optimal('01')
end

function test_optimal_02
% 4D input & output
    assert_optimal('02')
end

function test_optimal_03
% 5D input & output
    assert_optimal('03')
end

function test_optimal_04
% 5D input & output
    assert_optimal('04')
end

%% ASSERTIONS

function assert_optimal(instance)
    [data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft] = get_input(instance);
    actual   = model.data.convolutions.optimal(data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft);
    expected = get_expected(instance);
    assertEqual(actual, expected);
end

%% TEST UTILITIES

function [data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft] = get_input(instance)
    input               = load(['data/input/optimal_',instance,'.mat']);
    data                = input.data;
    filter_fft          = input.filter_fft;
    half_size_filter    = input.half_size_filter;
    fft_flag            = input.fft_flag;
    avoid_circshift_fft = input.avoid_circshift_fft;
end

function expected = get_expected(instance)
    expected = load(['data/expected/optimal_',instance,'.mat']);
    expected = expected.res;
end