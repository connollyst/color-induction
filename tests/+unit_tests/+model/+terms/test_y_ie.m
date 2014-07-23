function test_suite = test_y_ie
  initTestSuite;
end

%% TEST FFT DISABLED

function test_y_ie_3D_t01_i01
    data_name     = '3D_t01_i01';
    use_fft       = false;
    assert_y_ie(data_name, use_fft);
end

function test_y_ie_3D_t01_i02
    data_name     = '3D_t01_i02';
    use_fft       = false;
    assert_y_ie(data_name, use_fft);
end

function test_y_ie_3D_t01_i03
    data_name     = '3D_t01_i03';
    use_fft       = false;
    assert_y_ie(data_name, use_fft);
end

function test_y_ie_3D_t04_i01
    data_name     = '3D_t04_i01';
    use_fft       = false;
    assert_y_ie(data_name, use_fft);
end

%% TEST FFT ENABLED

function test_y_ie_3D_t01_i01_fft
    data_name     = '3D_t01_i01';
    use_fft       = true;
    assert_y_ie(data_name, use_fft);
end

function test_y_ie_3D_t01_i02_fft
    data_name     = '3D_t01_i02';
    use_fft       = true;
    assert_y_ie(data_name, use_fft);
end

function test_y_ie_3D_t01_i03_fft
    data_name     = '3D_t01_i03';
    use_fft       = true;
    assert_y_ie(data_name, use_fft);
end

function test_y_ie_3D_t04_i01_fft
    data_name     = '3D_t04_i01';
    use_fft       = true;
    assert_y_ie(data_name, use_fft);
end

%% ASSERTIONS

function assert_y_ie(instance, use_fft)
    config                    = get_config(use_fft);
    [gx_padded, interactions] = get_input(instance, config);
    y_ie                      = model.terms.y_ie(gx_padded, interactions, config);
    expected                  = get_expected(instance);
    assertEqualData(y_ie, expected.y_ie);
end

%% TEST UTILITIES

function config = get_config(use_fft)
    config = get_test_config(40, 40, 3, 2);
    config.compute.use_fft = use_fft;
    config.zli.interaction.color.enabled = false;
end

function [gx_padded, interactions] = get_input(instance, config)
    input        = load(['data/input/get_excitation_inhibition_',instance,'.mat']);
    gx_padded    = input.gx_padded;
    interactions = model.terms.get_interactions(config);
end

function expected = get_expected(instance)
    expected = load(['data/expected/get_excitation_inhibition_',instance,'.mat']);
end