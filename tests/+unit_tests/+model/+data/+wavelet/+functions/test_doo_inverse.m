function test_suite = test_doo_inverse
  initTestSuite;
end

function test_rgby_conversion
% We use the RGBY colorspace conversion in test assertions. We thus expect
% the transformation to be consistent to the pixel.
    % Given
    original = little_peppers();
    % When
    a = model.data.wavelet.functions.opponent.rgby(original);
    b = model.data.wavelet.functions.opponent.rgby(original);
    % Then
    assertEqualData(a, b);
end

function test_image_recovery
    % Given
    n_scales = 5;
    original = little_peppers();
    expected = model.data.wavelet.functions.opponent.rgby(original);
    config   = make_config('doo', n_scales);
    % When
    [wavelets, residuals] = model.data.wavelet.functions.doo(original, config);
    recovered = model.data.wavelet.functions.doo_inverse(wavelets, residuals);
    % Then (note: tolerant to floating point errors)
    assertElementsAlmostEqual(recovered, expected);
end

%% TEST UTILITIES

function config = make_config(transform, n_scales)
    config = configurations.double_opponent();
    config.zli.n_membr     = 3;
    config.wave.n_scales   = n_scales;
    config.wave.transform  = transform;
    config.display.logging = 0;
    config.display.plot    = 0;
end