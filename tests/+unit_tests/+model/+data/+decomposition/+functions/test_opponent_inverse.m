function test_suite = test_opponent_inverse
  initTestSuite;
end

function test_rgby_conversion
% We use the RGBY colorspace conversion in test assertions. We thus expect
% the transformation to be consistent to the pixel.
    % Given
    original = little_peppers();
    % When
    a = model.data.color.rgb2itti(original);
    b = model.data.color.rgb2itti(original);
    % Then
    assertEqualData(a, b);
end

function test_image_recovery_with_rgb2itti
    % Given
    n_scales = 5;
    original = little_peppers();
    expected = model.data.color.rgb2itti(original);
    config   = make_config(n_scales);
    config.rf.method = 'rgb2itti';
    % When
    [decompositions, residuals] = model.data.decomposition.functions.opponent(original, config);
    recovered = model.data.decomposition.functions.opponent_inverse(decompositions, residuals);
    % Then (note: tolerant to floating point errors)
    assertElementsAlmostEqual(recovered, expected);
end

function test_image_recovery_with_rgb2opp
    % Given
    n_scales = 5;
    original = little_peppers();
    expected = model.data.color.rgb2opp(original);
    config   = make_config(n_scales);
    config.rf.method = 'rgb2opp';
    % When
    [decompositions, residuals] = model.data.decomposition.functions.opponent(original, config);
    recovered = model.data.decomposition.functions.opponent_inverse(decompositions, residuals);
    % Then (note: tolerant to floating point errors)
    assertElementsAlmostEqual(recovered, expected);
end

%% TEST UTILITIES

function config = make_config(n_scales)
    config = configurations.default;
    config.zli.n_membr     = 3;
    config.wave.n_scales   = n_scales;
    config.display.logging = 0;
    config.display.plot    = 0;
end