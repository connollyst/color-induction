function test_suite = test_apply
  initTestSuite;
end

function test_no_replication_of_single_image
% If we have a single image and a single time step,
% there should be just a single wavelet and residual.
    n_membr = 1;
    I = make_I(1);
    config = make_config(n_membr, 3);
    [wavelets, residuals] = model.data.decomposition.apply(I, config);
    assertEqual(length(wavelets),  1);
    assertEqual(length(residuals), 1);
end

function test_no_replication_of_many_images
% If we have the same number of images as time steps,
% we should get back one wavelet and residual for each input.
    n_membr = 4;
    I = make_I(4);
    config = make_config(n_membr, 3);
    [wavelets, residuals] = model.data.decomposition.apply(I, config);
    assertEqual(length(wavelets),  n_membr);
    assertEqual(length(residuals), n_membr);
end

function test_replication_of_single_image
% If we have a single image and lots of time steps,
% the wavelet and residual should be replicated for each step.
    n_membr = 42;
    I = make_I(1);
    config = make_config(n_membr, 3);
    [wavelets, residuals] = model.data.decomposition.apply(I, config);
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
    config = make_config(n_membr, 3);
    [wavelets, residuals] = model.data.decomposition.apply(I, config);
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
    config = make_config(n_membr, 3);
    err_thrown = 0;
    try
        model.data.apply.apply(I, config);
    catch
        err_thrown = 1;
    end
    if ~err_thrown
        error('Expected error thrown in test.');
    end
end

%% TEST UTILITIES

function I = make_I(I_size)
    I = cell(I_size, 1);
    for i=1:I_size
        I{i} = ones(20, 30, 2) * i;
    end
end

function config = make_config(n_membr, n_scales)
    config.zli.n_membr     = n_membr;
    config.wave.n_scales   = n_scales;
    config.wave.n_orients  = 3;
    config.wave.transform  = 'dwt';
    config.display.logging = 0;
    config.display.plot    = 0;
end