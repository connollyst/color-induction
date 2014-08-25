function test_suite = test_dwt_rgby_inverse
  initTestSuite;
end

function test_single_and_double_conversion_consistency
    % Given
    original  = little_peppers();
    % When
    a = model.data.decomposition.functions.opponent.rgby(original);
    b = model.data.decomposition.functions.opponent.rgby(original);
    % Then
    assertEqualData(a, b);
end

function test_single_opponent_recovery_with_1_scale
    % Given
    n_orients = 1;  % SO only
    n_scales  = 1;
    assertRecovery(n_orients, n_scales)
end

function test_single_opponent_recovery_with_2_scales
    % Given
    n_orients = 1;  % SO only
    n_scales  = 2;
    assertRecovery(n_orients, n_scales)
end

function test_single_opponent_recovery_with_3_scales
    % Given
    n_orients = 1;  % SO only
    n_scales  = 3;
    assertRecovery(n_orients, n_scales)
end

function test_double_opponent_recovery_with_1_scale
    % Given
    n_orients = 3;  % DO only
    n_scales  = 1;
    assertRecovery(n_orients, n_scales)
end

function test_double_opponent_recovery_with_2_scales
    % Given
    n_orients = 3;  % DO only
    n_scales  = 2;
    assertRecovery(n_orients, n_scales)
end

function test_double_opponent_recovery_with_3_scales
    % Given
    n_orients = 3;  % DO only
    n_scales  = 3;
    assertRecovery(n_orients, n_scales)
end

function test_single_and_double_opponent_recovery_with_1_scale
    % Given
    n_orients = 4;  % SO & DO
    n_scales  = 1;
    assertRecovery(n_orients, n_scales)
end

function test_single_and_double_opponent_recovery_with_2_scales
    % Given
    n_orients = 4;  % SO & DO
    n_scales  = 2;
    assertRecovery(n_orients, n_scales)
end

function test_single_and_double_opponent_recovery_with_3_scales
    % Given
    n_orients = 4;  % SO & DO
    n_scales  = 3;
    assertRecovery(n_orients, n_scales)
end

function assertRecovery(n_orients, n_scales)
    data = load('tests/data/rgb_40_40_3.mat');
    original = data.img;
    expected  = model.data.color.rgb2rgby(original);
    config    = make_config(n_scales, n_orients);
    % When
    [decompositions, residuals] = model.data.decomposition.functions.dwt_rgby(original, config);
    recovered = model.data.decomposition.functions.dwt_rgby_inverse(decompositions, residuals);
    % Then (note: tolerant to floating point errors)
    assertElementsAlmostEqual(recovered, expected);
end

%% TEST UTILITIES

function config = make_config(n_scales, n_orients)
    config = configurations.wavelet_opponent();
    config.zli.n_membr     = 3;
    config.wave.n_orients  = n_orients;
    config.wave.n_scales   = n_scales;
    config.display.logging = 0;
    config.display.plot    = 0;
end