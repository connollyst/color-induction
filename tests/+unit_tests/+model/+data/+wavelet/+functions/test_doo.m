function test_suite = test_doo
  initTestSuite;
end

function test_decomposition_dimensions
    n_scales = 5;
    I = make_black_I();
    config = make_config('doo', n_scales);
    [wavelets, ~] = model.data.wavelet.functions.doo(I, config);
    assertEqual(size(wavelets, 1),  size(I, 1));
    assertEqual(size(wavelets, 2),  size(I, 2));
    assertEqual(size(wavelets, 3),  4); % RGBY
    assertEqual(size(wavelets, 4),  n_scales);
    assertEqual(size(wavelets, 5),  3); % horizontal, diagonal, vertical
end

function test_decomposition_values_when_black
    n_scales = 5;
    I = make_black_I();
    config = make_config('doo', n_scales);
    [wavelets, ~] = model.data.wavelet.functions.doo(I, config);
    assertEqual(max(wavelets(:)), 0);
    assertEqual(min(wavelets(:)), 0);
end

function test_decomposition_values_when_white
% Tests for a bug seen with large receptive fields on small images.
    n_scales = 5;
    I = make_white_I();
    config = make_config('doo', n_scales);
    [wavelets, ~] = model.data.wavelet.functions.doo(I, config);
    assertEqual(max(wavelets(:)), 0);
    assertEqual(min(wavelets(:)), 0);
end

%% TEST UTILITIES

function I = make_black_I()
    I = zeros(20, 30, 3);
end

function I = make_white_I()
    I = ones(20, 30, 3);
end

function config = make_config(transform, n_scales)
    config = configurations.double_opponent();
    config.zli.n_membr     = 3;
    config.wave.n_scales   = n_scales;
    config.wave.transform  = transform;
    config.display.logging = 0;
    config.display.plot    = 0;
end