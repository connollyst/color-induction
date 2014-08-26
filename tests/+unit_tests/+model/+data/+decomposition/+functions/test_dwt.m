function test_suite = test_dwt
  initTestSuite;
end

function test_dwt_decomposition_dimensions
    n_scales = 3;
    I = little_peppers();
    I = model.data.color.rgb2rgby(I);
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.dwt(I, config);
    assertEqual(size(decompositions, 1),  size(I, 1));
    assertEqual(size(decompositions, 2),  size(I, 2));
    assertEqual(size(decompositions, 3),  4); % RGBY
    assertEqual(size(decompositions, 4),  n_scales);
    assertEqual(size(decompositions, 5),  3); % horizontal, diagonal, vertical
end

function test_dwt_decomposition_values_when_black
    n_scales = 3;
    I = make_black_I();
    I = model.data.color.rgb2rgby(I);
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.dwt(I, config);
    assertEqual(max(decompositions(:)), 0);
    assertEqual(min(decompositions(:)), 0);
end

function test_dwt_decomposition_values_when_white
% Tests for a bug seen with large receptive fields on small images.
    n_scales = 3;
    I = make_white_I();
    I = model.data.color.rgb2rgby(I);
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.dwt(I, config);
    assertElementsAlmostEqual(max(decompositions(:)), 0);
    assertElementsAlmostEqual(min(decompositions(:)), 0);
end

function test_dwt_all_scales_contain_signal
    n_scales = 3;
    I = little_peppers();
    I = model.data.color.rgb2rgby(I);
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.dwt(I, config);
    for s=1:n_scales
        scale = decompositions(:,:,:,s,:);
        assertTrue(max(scale(:)) ~= 0, ...
                    ['Expected signal in scale ', num2str(s)]);
    end
end

function test_dwt_no_signal_for_synthetic_black_and_white_image
    n_scales = 1;
    I = make_synthetic_I();
    I = model.data.color.rgb2rgby(I);
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.dwt(I, config);
    for s=1:n_scales
        scale = decompositions(:,:,:,s,:);
        assertTrue(max(scale(:)) == 0, ...
                    ['Didnt expect any signal in scale ', num2str(s)]);
    end
end

function test_dwt_signal_for_synthetic_color_image
    n_scales = 1;
    I = make_synthetic_I();
    I(:,:,1) = I(:,:,1) * 0.7;
    I(:,:,2) = I(:,:,2) * 0.3;
    I(:,:,3) = I(:,:,3) * 0.2;
    I = model.data.color.rgb2rgby(I);
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.dwt(I, config);
    for s=1:n_scales
        scale = decompositions(:,:,:,s,:);
        assertTrue(max(scale(:)) ~= 0, ...
                    ['Expected signal in scale ', num2str(s)]);
    end
end

function test_dwt_higher_scales_contain_weaker_signal
    n_scales = 3;
    I = little_peppers;
    I = model.data.color.rgb2rgby(I);
    config = make_config(n_scales);
    [decompositions, ~] = model.data.decomposition.functions.dwt(I, config);
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

%% ASSERT OUTPUT VALUE RANGES

function test_dwt_single_opponent_lab_channel_1_minimum_value
    n_orients =  1;
    channel   =  1;
    minimum   = -50;
    maximum   =  0;
    assertMinimumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_opponent_lab_channel_2_minimum_value
    n_orients =  1;
    channel   =  2;
    minimum   = -Inf;
    maximum   =  0;
    assertMinimumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_opponent_lab_channel_3_minimum_value
    n_orients =  1;
    channel   =  3;
    minimum   = -Inf;
    maximum   =  0;
    assertMinimumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_opponent_lab_channel_1_maximum_value
    n_orients =  1;
    channel   =  1;
    minimum   =  0;
    maximum   =  50;
    assertMaximumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_opponent_lab_channel_2_maximum_value
    n_orients =  1;
    channel   =  2;
    minimum   =  0;
    maximum   =  Inf;
    assertMaximumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_opponent_lab_channel_3_maximum_value
    n_orients =  1;
    channel   =  3;
    minimum   =  0;
    maximum   =  Inf;
    assertMaximumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_double_opponent_lab_channel_1_minimum_value
    n_orients =  3;
    channel   =  1;
    minimum   = -50;
    maximum   =  0;
    assertMinimumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_double_opponent_lab_channel_2_minimum_value
    n_orients =  3;
    channel   =  2;
    minimum   = -Inf;
    maximum   =  0;
    assertMinimumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_double_opponent_lab_channel_3_minimum_value
    n_orients =  3;
    channel   =  3;
    minimum   = -Inf;
    maximum   =  0;
    assertMinimumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_double_opponent_lab_channel_1_maximum_value
    n_orients =  3;
    channel   =  1;
    minimum   =  0;
    maximum   =  50;
    assertMaximumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_double_opponent_lab_channel_2_maximum_value
    n_orients =  3;
    channel   =  2;
    minimum   =  0;
    maximum   =  Inf;
    assertMaximumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_double_opponent_lab_channel_3_maximum_value
    n_orients =  3;
    channel   =  3;
    minimum   =  0;
    maximum   =  Inf;
    assertMaximumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_and_double_opponent_lab_channel_1_minimum_value
    n_orients =  4;
    channel   =  1;
    minimum   = -50;
    maximum   =  0;
    assertMinimumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_and_double_opponent_lab_channel_2_minimum_value
    n_orients =  4;
    channel   =  2;
    minimum   = -Inf;
    maximum   =  0;
    assertMinimumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_and_double_opponent_lab_channel_3_minimum_value
    n_orients =  4;
    channel   =  3;
    minimum   = -Inf;
    maximum   =  0;
    assertMinimumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_and_double_opponent_lab_channel_1_maximum_value
    n_orients =  4;
    channel   =  1;
    minimum   =  0;
    maximum   =  50;
    assertMaximumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_and_double_opponent_lab_channel_2_maximum_value
    n_orients =  4;
    channel   =  2;
    minimum   =  0;
    maximum   =  Inf;
    assertMaximumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

function test_dwt_single_and_double_opponent_lab_channel_3_maximum_value
    n_orients =  4;
    channel   =  3;
    minimum   =  0;
    maximum   =  Inf;
    assertMaximumValue(make_synthetic_lab, n_orients, channel, minimum, maximum);
end

%% ASSERT OUTPUT MATRIX DIMENSIONS

function test_dwt_single_and_double_opponent_dimensions_at_2_scales
    n_scales = 2;
    I = little_peppers();
    I = model.data.color.rgb2rgby(I);
    config = make_config(n_scales);
    config.wave.n_orients = 4;
    [signal, ~] = model.data.decomposition.functions.dwt(I, config);
    assertEqual(size(signal, 1),  size(I, 1));
    assertEqual(size(signal, 2),  size(I, 2));
    assertEqual(size(signal, 3),  4); % RGBY
    assertEqual(size(signal, 4),  n_scales);
    assertEqual(size(signal, 5),  4); % horizontal, diagonal, vertical, and non-oriented
end

function test_dwt_single_and_double_opponent_dimensions_at_3_scales
    n_scales = 3;
    I = little_peppers();
    I = model.data.color.rgb2rgby(I);
    config = make_config(n_scales);
    config.wave.n_orients = 4;
    [signal, ~] = model.data.decomposition.functions.dwt(I, config);
    assertEqual(size(signal, 1),  size(I, 1));
    assertEqual(size(signal, 2),  size(I, 2));
    assertEqual(size(signal, 3),  4); % RGBY
    assertEqual(size(signal, 4),  n_scales);
    assertEqual(size(signal, 5),  4); % horizontal, diagonal, vertical, and non-oriented
end

%% TEST ASSERTIONS

function assertMinimumValue(I, n_orients, channel_i, expected_min, expected_max)
    n_scales = 2;
    config = make_config(n_scales);
    config.wave.n_orients = n_orients;
    [signal, ~] = model.data.decomposition.functions.dwt(I, config);
    channel = signal(:,:,channel_i,:,:);
    min_signal = min(channel(:));
    assertTrue(min_signal >= expected_min, ['Expected minimum signal >= ',num2str(expected_min),', was ',num2str(min_signal)]);
    assertTrue(min_signal <= expected_max, ['Expected minimum signal <= ',num2str(expected_max),', was ',num2str(min_signal)]);
end

function assertMaximumValue(I, n_orients, channel_i, expected_min, expected_max)
    n_scales = 2;
    config = make_config(n_scales);
    config.wave.n_orients = n_orients;
    [signal, ~] = model.data.decomposition.functions.dwt(I, config);
    channel = signal(:,:,channel_i,:,:);
    min_signal = max(channel(:));
    assertTrue(min_signal <= expected_max, ['Expected maximum signal <= ',num2str(expected_max),', was ',num2str(min_signal)]);
    assertTrue(min_signal >= expected_min, ['Expected maximum signal >= ',num2str(expected_min),', was ',num2str(min_signal)]);
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

function I = make_synthetic_lab()
    data = load('tests/data/rgb_40_40_3.mat');
    I = data.img;
    I = model.data.color.rgb2lab(I);
end

function I = make_synthetic_rgby()
    data = load('tests/data/rgb_40_40_3.mat');
    I = data.img;
    I = model.data.color.rgb2rgby(I);
end

function config = make_config(n_scales)
    config = configurations.double_opponent();
    config.zli.n_membr     = 3;
    config.wave.n_scales   = n_scales;
    config.wave.transform  = 'dwt';
    config.display.logging = 0;
    config.display.plot    = 0;
end