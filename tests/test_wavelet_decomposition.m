function test_suite = test_wavelet_decompositon
%TEST_ADD_PADDING Test suite for model.data.wavelet.decomposition()
  initTestSuite;
end

function test_no_replication_of_single_image
% If we have a single image and a single time step,
% there should be just a single wavelet and residual.
    n_membr = 1;
    I = make_I(1);
    config = make_config(n_membr, 'DWD_orient_undecimated', 3);
    [wavelets, residuals] = model.data.wavelet.decomposition(I, config);
    assertEqual(length(wavelets),  1);
    assertEqual(length(residuals), 1);
end

function test_no_replication_of_many_images
% If we have the same number of images as time steps,
% we should get back one wavelet and residual for each input.
    n_membr = 4;
    I = make_I(4);
    config = make_config(n_membr, 'DWD_orient_undecimated', 3);
    [wavelets, residuals] = model.data.wavelet.decomposition(I, config);
    assertEqual(length(wavelets),  n_membr);
    assertEqual(length(residuals), n_membr);
end

function test_replication_of_single_image
% If we have a single image and lots of time steps,
% the wavelet and residual should be replicated for each step.
    n_membr = 42;
    I = make_I(1);
    config = make_config(n_membr, 'DWD_orient_undecimated', 3);
    [wavelets, residuals] = model.data.wavelet.decomposition(I, config);
    assertEqual(length(wavelets),  n_membr);
    assertEqual(length(residuals), n_membr);
    % The one wavelet should be replicated 42 times
    assertEqualData(wavelets{1}, wavelets{2});
    assertEqualData(wavelets{1}, wavelets{4});
    assertEqualData(wavelets{1}, wavelets{10});
    assertEqualData(wavelets{1}, wavelets{40});
    assertEqualData(wavelets{1}, wavelets{42});
    % The one residual should be replicated 42 times
    assertEqualData(residuals{1}, residuals{2});
    assertEqualData(residuals{1}, residuals{4});
    assertEqualData(residuals{1}, residuals{10});
    assertEqualData(residuals{1}, residuals{40});
    assertEqualData(residuals{1}, residuals{42});
end

function test_replication_of_many_images
% If we have multiple images and even more time steps,
% the wavelets and residuals should be replicated as needed.
    n_membr = 42;
    I = make_I(5);
    config = make_config(n_membr, 'DWD_orient_undecimated', 3);
    [wavelets, residuals] = model.data.wavelet.decomposition(I, config);
    assertEqual(length(wavelets),  n_membr);
    assertEqual(length(residuals), n_membr);
    % The 5 wavelets should be replicated to fill the required steps
    assertEqualData(wavelets{1}, wavelets{6});
    assertEqualData(wavelets{2}, wavelets{7});
    assertEqualData(wavelets{3}, wavelets{8});
    assertEqualData(wavelets{4}, wavelets{9});
    assertEqualData(wavelets{5}, wavelets{10});
    assertEqualData(wavelets{1}, wavelets{11});
    assertEqualData(wavelets{5}, wavelets{40});
    assertEqualData(wavelets{1}, wavelets{41});
    assertEqualData(wavelets{2}, wavelets{42});
    % The 5 wavelets should be replicated to fill the required steps
    assertEqualData(residuals{1}, residuals{6});
    assertEqualData(residuals{2}, residuals{7});
    assertEqualData(residuals{3}, residuals{8});
    assertEqualData(residuals{4}, residuals{9});
    assertEqualData(residuals{5}, residuals{10});
    assertEqualData(residuals{1}, residuals{11});
    assertEqualData(residuals{5}, residuals{40});
    assertEqualData(residuals{1}, residuals{41});
    assertEqualData(residuals{2}, residuals{42});
end

function test_error_with_too_many_images
% If we have more input images than time steps,
% an appropriate error should be thrown.
    n_membr = 1;
    I = make_I(2);
    config = make_config(n_membr, 'DWD_orient_undecimated', 3);
    err_thrown = 0;
    try
        model.data.wavelet.decomposition(I, config);
    catch
        err_thrown = 1;
    end
    if ~err_thrown
        error('Expected error thrown in test.');
    end
end

%% TEST WAVELET DECOMPOSITION FUNCTIONS

function test_a_trous_data_structure
    n_membr     = 1;
    n_imgs      = 1;
    n_cols      = 20;
    n_rows      = 30;
    n_channels  = 2;
    n_scales    = 3;
    n_orients   = 1;    % a trous is not an oriented decomposition
    n_residuals = 1;    % there is only ever one residual orientation
    config = make_config(n_membr, 'a_trous', n_scales);
    [wavelets, residuals] = model.data.wavelet.decomposition(make_I(n_imgs), config);
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

function test_DWD_orient_undecimated_data_structure
    n_membr     = 1;
    n_imgs      = 1;
    n_cols      = 20;
    n_rows      = 30;
    n_channels  = 2;
    n_scales    = 3;
    n_orients   = 3;    % 3 orientations: vertical, horizontal, & diagonal
    n_residuals = 1;    % there is only ever one residual orientation
    config = make_config(n_membr, 'DWD_orient_undecimated', n_scales);
    [wavelets, residuals] = model.data.wavelet.decomposition(make_I(n_imgs), config);
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

function test_a_trous_inversion
    img_in = im2double(imread('cameraman.tif'));
    config = make_config(1, 'a_trous', 3);
    [wavelets, residuals] = model.data.wavelet.decomposition({ img_in }, config);
    img_out = model.data.wavelet.decomposition_inverse(wavelets, residuals, config);
    assertSame(img_in, img_out{1});
end

function test_DWD_orient_undecimated_inversion
    img_in = im2double(imread('cameraman.tif'));
    config = make_config(1, 'DWD_orient_undecimated', 3);
    [wavelets, residuals] = model.data.wavelet.decomposition({ img_in }, config);
    img_out = model.data.wavelet.decomposition_inverse(wavelets, residuals, config);
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
    config.zli.n_membr    = n_membr;
    config.wave.n_scales  = n_scales;
    config.wave.transform = transform;
end

function assertSame(img_in, img_out)
    img_diff = img_in - img_out;
    img_diff_amount = max(abs(img_diff(:)));
    assertTrue(img_diff_amount < 0.001);
end