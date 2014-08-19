function test_suite = test_opponent_inverse
  initTestSuite;
end

function test_rgby_conversion
% We use the RGBY colorspace conversion in test assertions. We thus expect
% the transformation to be consistent to the pixel.
    % Given
    original = little_peppers();
    % When
    a = model.data.decomposition.functions.opponent.rgby(original);
    b = model.data.decomposition.functions.opponent.rgby(original);
    % Then
    assertEqualData(a, b);
end

function test_image_recovery
    % Given
    n_scales = 5;
    original = little_peppers();
    expected = model.data.decomposition.functions.opponent.rgby(original);
    config   = make_config(n_scales);
    % When
    [decompositions, residuals] = model.data.decomposition.functions.opponent(original, config);
    recovered = model.data.decomposition.functions.opponent_inverse(decompositions, residuals);
    % Then (note: tolerant to floating point errors)
    assertElementsAlmostEqual(recovered, expected);
end

%% TEST UTILITIES

function config = make_config(n_scales)
    config = configurations.double_opponent();
    config.zli.n_membr     = 3;
    config.wave.n_scales   = n_scales;
    config.display.logging = 0;
    config.display.plot    = 0;
end