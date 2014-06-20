function test_suite = test_optima
%TEST_ADD_PADDING Test suite for convolutions.optima()
  initTestSuite;
end

function test_optima_01
% 4D input & output
    assert_optima('01')
end

function test_optima_02
% 4D input & output
    assert_optima('02')
end

function test_optima_03
% Test that the 5D input matches the 4D output from the old algorithm
    [data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft] = get_input('03');
    actual   = convolutions.optima(data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft);
    expected = get_expected('01');
    assertEqualMatrices(actual, expected);
end

function test_optima_04
% 5D input & output
    assert_optima('04')
end

%% ASSERTIONS

function assert_optima(instance)
    [data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft] = get_input(instance);
    actual   = convolutions.optima(data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft);
    expected = get_expected(instance);
    assertEqual(actual, expected);
end

%% TEST UTILITIES

function [data, filter_fft, half_size_filter, fft_flag, avoid_circshift_fft] = get_input(instance)
    input                = load(['data/input_to_optima_',instance,'.mat']);
    data                 = input.data;
    filter_fft           = input.filter_fft;
    half_size_filter     = input.half_size_filter;
    fft_flag             = input.fft_flag;
    if isfield(input, 'avoid_circshift_fft')
        avoid_circshift_fft = input.avoid_circshift_fft;
    else
        avoid_circshift_fft = 0;
    end
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_optima_',instance,'.mat']);
    expected = expected.res;
end