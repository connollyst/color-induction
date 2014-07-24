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
    [gx, interactions, config] = get_input(instance, use_fft);
    actual_y_ie                = model.terms.y_ie(gx, interactions, config);
    expected_y_ie              = get_expected(instance);
    assertEqualData(actual_y_ie, expected_y_ie);
end

%% TEST UTILITIES

function [gx, interactions, config] = get_input(instance, use_fft)
    input  = load(['data/input/update_xy_',instance,'.mat']);
    x      = input.x;
    gx     = model.terms.gx(x);
    config = get_test_config(40, 40, 3, 2);
    config.compute.use_fft = use_fft;
    config.zli.interaction.orient.enabled = true;
    config.zli.interaction.scale.enabled  = true;
    config.zli.interaction.color.enabled  = false;
    interactions = model.terms.get_interactions(config);
end

function expected_y_ie = get_expected(instance)
    expected = load(['data/expected/get_excitation_inhibition_',instance,'.mat']);
    expected_y_ie = expected.y_ie;
end