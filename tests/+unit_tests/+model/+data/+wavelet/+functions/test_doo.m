function test_suite = test_doo
  initTestSuite;
end

function test_decomposition_dimensions
    n_scales = 5;
    I = little_peppers();
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

function test_all_scales_contain_signal
    n_scales = 5;
    I = little_peppers;
    config = make_config('doo', n_scales);
    [wavelets, ~] = model.data.wavelet.functions.doo(I, config);
    for s=1:n_scales
        scale = wavelets(:,:,:,s,:);
        assertTrue(max(scale(:)) ~= 0, ...
                    ['Expected signal in scale ', num2str(s)]);
    end
end

function test_signal_range_zero_to_one
    n_scales = 5;
    I = little_peppers();
    config = make_config('doo', n_scales);
    [wavelets, ~] = model.data.wavelet.functions.doo(I, config);
    for s=1:n_scales
        scale = wavelets(:,:,:,s,:);
        max_scale = max(scale(:));
        min_scale = min(scale(:));
        assertTrue(min_scale >= 0, ...
                    ['Expected signal greater than 0 in scale ', num2str(s), ...
                     ', found: ', num2str(min_scale)]);
        assertTrue(max_scale <= 1, ...
                    ['Expected signal less than 1 in scale ', num2str(s), ...
                     ', found: ', num2str(max_scale)]);
    end
end

function test_higher_scales_contain_weaker_signal
    n_scales = 5;
    I = little_peppers;
    config = make_config('doo', n_scales);
    [wavelets, ~] = model.data.wavelet.functions.doo(I, config);
    running_max = Inf;
    for s=1:n_scales
        scale = wavelets(:,:,:,s,:);
        current_max = max(scale(:));
        assertTrue(current_max < running_max,   ...
                    ['Expected signal in scale ', num2str(s),   ...
                     ' greater than ', num2str(s-1),            ...
                     ', was ', num2str(current_max),            ...
                     ' compared to ', num2str(running_max)      ...
                     ]);
    end
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