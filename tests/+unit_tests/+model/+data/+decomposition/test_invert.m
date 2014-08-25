function test_suite = test_invert
  initTestSuite;
end

function test_swt_data_structure
    n_membr     = 1;
    n_imgs      = 1;
    n_cols      = 20;
    n_rows      = 30;
    n_channels  = 2;
    n_scales    = 3;
    n_orients   = 1;    % a trous is not an oriented decomposition
    n_residuals = 1;    % there is only ever one residual orientation
    config = make_config(n_membr, 'swt', n_scales);
    [wavelets, residuals] = model.data.decomposition.apply(make_I(n_imgs), config);
    assertEqual(n_membr, length(wavelets));
    assertEqual(n_membr, length(residuals));
    wavelet  = wavelets{1};
    residual = residuals{1};
    assertEqual(n_cols,      size(wavelet, 1));
    assertEqual(n_rows,      size(wavelet, 2));
    assertEqual(n_channels,  size(wavelet, 3));
    assertEqual(n_scales,    size(wavelet, 4));
    assertEqual(n_orients,   size(wavelet, 5));
    assertEqual(n_cols,      size(residual, 1));
    assertEqual(n_rows,      size(residual, 2));
    assertEqual(n_channels,  size(residual, 3));
    assertEqual(n_scales,    size(residual, 4));
    assertEqual(n_residuals, size(residual, 5));
end

function test_dwt_data_structure
    n_membr     = 1;
    n_imgs      = 1;
    n_cols      = 20;
    n_rows      = 30;
    n_channels  = 2;
    n_scales    = 3;
    n_orients   = 3;    % 3 orientations: vertical, horizontal, & diagonal
    n_residuals = 1;    % there is only ever one residual orientation
    config = make_config(n_membr, 'dwt', n_scales);
    [wavelets, residuals] = model.data.decomposition.apply(make_I(n_imgs), config);
    assertEqual(n_membr, length(wavelets));
    assertEqual(n_membr, length(residuals));
    wavelet  = wavelets{1};
    residual = residuals{1};
    assertEqual(n_cols,      size(wavelet, 1));
    assertEqual(n_rows,      size(wavelet, 2));
    assertEqual(n_channels,  size(wavelet, 3));
    assertEqual(n_scales,    size(wavelet, 4));
    assertEqual(n_orients,   size(wavelet, 5));
    assertEqual(n_cols,      size(residual, 1));
    assertEqual(n_rows,      size(residual, 2));
    assertEqual(n_channels,  size(residual, 3));
    assertEqual(n_scales,    size(residual, 4));
    assertEqual(n_residuals, size(residual, 5));
end

function test_swt_inversion
    img_in = im2double(imread('cameraman.tif'));
    config = make_config(1, 'swt', 3);
    [wavelets, residuals] = model.data.decomposition.apply({ img_in }, config);
    img_out = model.data.decomposition.invert(wavelets, residuals, config);
    assertSame(img_in, img_out{1});
end

function test_dwt_inversion
    img_in = im2double(imread('cameraman.tif'));
    config = make_config(1, 'dwt', 3);
    [wavelets, residuals] = model.data.decomposition.apply({ img_in }, config);
    img_out = model.data.decomposition.invert(wavelets, residuals, config);
    assertSame(img_in, img_out{1});
end

%% TEST UTILITIES

function I = make_I(I_size)
    I = cell(I_size, 1);
    for i=1:I_size
        I{i} = ones(20, 30, 2) * i;
    end
end

function config = make_config(n_membr, transform, n_scales)
    config.zli.n_membr     = n_membr;
    config.wave.n_scales   = n_scales;
    config.wave.n_orients  = 3;
    config.wave.transform  = transform;
    config.display.logging = 0;
    config.display.plot    = 0;
end

function assertSame(img_in, img_out)
    img_diff = img_in - img_out;
    img_diff_amount = max(abs(img_diff(:)));
    assertTrue(img_diff_amount < 0.001);
end