function test_suite = test_optima_fft
%TEST_ADD_PADDING Test suite for convolutions.optima_fft()
  initTestSuite;
end

function test_optima_fft_01
    assert_optima_fft('01')
end

function test_optima_fft_02
    assert_optima_fft('02')
end

%% ASSERTIONS

function assert_optima_fft(instance)
    [data, filter_fft, half_size_filter, avoid_circshift_fft] = get_input(instance);
    actual   = convolutions.optima_fft(data, filter_fft, half_size_filter, avoid_circshift_fft);
    expected = get_expected(instance);
    assertEqual(actual, expected);
end

%% TEST UTILITIES

function [data, filter_fft, half_size_filter, avoid_circshift_fft] = get_input(instance)
    input               = load(['data/input/optima_fft_',instance,'.mat']);
    data                = input.data;
    filter_fft          = input.filter_fft;
    half_size_filter    = input.half_size_filter;
    avoid_circshift_fft = input.avoid_circshift_fft;
end

function expected = get_expected(instance)
    expected = load(['data/expected/optima_fft_',instance,'.mat']);
    expected = expected.res;
end