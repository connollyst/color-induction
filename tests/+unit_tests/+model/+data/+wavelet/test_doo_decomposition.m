function test_suite = test_doo_decomposition
  initTestSuite;
end

function test_no_replication_of_single_image
    n_membr = 1;
    I = make_I(1);
    config = make_config(n_membr, 'doo', 3);
    [wavelets, residuals] = model.data.wavelet.decomposition(I, config);
    assertEqual(length(wavelets),  1);
    assertEqual(length(residuals), 1);
end

%% TEST UTILITIES

function I = make_I(I_size)
    I = cell(I_size, 1);
    for i=1:I_size
        I{i} = ones(20, 30, 3) * i;
    end
end

function config = make_config(n_membr, transform, n_scales)
    config = configurations.double_opponent();
    config.zli.n_membr     = n_membr;
    config.wave.n_scales   = n_scales;
    config.wave.transform  = transform;
    config.display.logging = 0;
    config.display.plot    = 0;
end