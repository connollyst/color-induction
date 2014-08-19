function test_suite = test_opponent
  initTestSuite;
end

function test_decomposition_dimensions
    n_scales = 5;
    I = little_peppers();
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.opponent(I, config);
    assertEqual(size(decompositions, 1),  size(I, 1));
    assertEqual(size(decompositions, 2),  size(I, 2));
    assertEqual(size(decompositions, 3),  4); % RGBY
    assertEqual(size(decompositions, 4),  n_scales);
    assertEqual(size(decompositions, 5),  3); % horizontal, diagonal, vertical
end

function test_decomposition_values_when_black
    n_scales = 5;
    I = make_black_I();
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.opponent(I, config);
    assertEqual(max(decompositions(:)), 0);
    assertEqual(min(decompositions(:)), 0);
end

function test_decomposition_values_when_white
% Tests for a bug seen with large receptive fields on small images.
    n_scales = 5;
    I = make_white_I();
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.opponent(I, config);
    assertElementsAlmostEqual(max(decompositions(:)), 0);
    assertElementsAlmostEqual(min(decompositions(:)), 0);
end

function test_all_scales_contain_signal
    n_scales = 5;
    I = little_peppers();
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.opponent(I, config);
    for s=1:n_scales
        scale = decompositions(:,:,:,s,:);
        assertTrue(max(scale(:)) ~= 0, ...
                    ['Expected signal in scale ', num2str(s)]);
    end
end

function test_signal_for_synthetic_black_and_white_image
% Note: If this test fails, it's probably because the excitation &
%       inhibition receptive fields are exactly equal. Is that Ok?
    n_scales = 1;
    I = make_synthetic_I();
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.opponent(I, config);
    for s=1:n_scales
        scale = decompositions(:,:,:,s,:);
        assertTrue(max(scale(:)) ~= 0, ...
                    ['Expected signal in scale ', num2str(s)]);
    end
end

function test_signal_for_synthetic_color_image
    n_scales = 1;
    I = make_synthetic_I();
    I(:,:,1) = I(:,:,1) * 0.7;
    I(:,:,2) = I(:,:,2) * 0.3;
    I(:,:,3) = I(:,:,3) * 0.2;
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.opponent(I, config);
    for s=1:n_scales
        scale = decompositions(:,:,:,s,:);
        assertTrue(max(scale(:)) ~= 0, ...
                    ['Expected signal in scale ', num2str(s)]);
    end
end

function test_signal_range_zero_to_one
    n_scales = 5;
    I = little_peppers();
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.opponent(I, config);
    for s=1:n_scales
        scale = decompositions(:,:,:,s,:);
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
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.opponent(I, config);
    running_max = Inf;
    for s=1:n_scales
        scale = decompositions(:,:,:,s,:);
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

function I = make_synthetic_I()
% A simple image for testing: a white square on a black background
    I = zeros(42, 42, 3);
    I(11:end-11,11:end-11,:) = 1;
end

function config = make_config(n_scales)
    config = configurations.double_opponent();
    config.zli.n_membr     = 3;
    config.wave.n_scales   = n_scales;
    config.wave.transform  = 'opponent';
    config.display.logging = 0;
    config.display.plot    = 0;
end