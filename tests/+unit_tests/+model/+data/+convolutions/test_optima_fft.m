function test_suite = test_optima_fft
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
    [data_fft, filter_fft, shift_size, avoid_circshift_fft] = get_input(instance);
    actual   = model.data.convolutions.optima_fft(data_fft, filter_fft, shift_size, avoid_circshift_fft);
    expected = get_expected(instance);
    assertEqual(actual, expected);
end

%% TEST UTILITIES

function [data, filter_fft, shift_size, avoid_circshift_fft] = get_input(instance)
    input               = load(['data/input/optima_fft_',instance,'.mat']);
    data                = input.data_fft;
    filter_fft          = input.filter_fft;
    shift_size          = input.shift_size;
    avoid_circshift_fft = input.avoid_circshift_fft;
end

function expected = get_expected(instance)
    expected = load(['data/expected/optima_fft_',instance,'.mat']);
    expected = expected.result;
end