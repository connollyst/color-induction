function test_suite = test_Inormalization
  initTestSuite;
end

function test_I_norm_3D_t01_i01
    assert_I_norm('3D_t01_i01')
end

function test_I_norm_3D_t01_i02
    assert_I_norm('3D_t01_i02')
end

function test_I_norm_3D_t01_i03
    assert_I_norm('3D_t01_i03')
end

function test_I_norm_3D_t04_i01
    assert_I_norm('3D_t04_i01')
end

%% ASSERTIONS

function assert_I_norm(instance)
    % TODO get input
    [norm_masks, gx, interactions, config] = get_input(instance);
    I_norm   = model.terms.Inormalization(gx, norm_masks, interactions.scale, config);
    expected = get_expected(instance);
    assertEqualData(I_norm, expected.I_norm);
end

%% TEST UTILITIES

function [norm_masks, gx, interactions, config] = get_input(instance)
    input            = load(['data/input/update_xy_',instance,'.mat']);
    x                = input.x;
    gx               = model.terms.gx(x);
    config           = get_test_config(40, 40, 3, 2);
    norm_masks       = model.data.normalization.get_masks(config);
    interactions     = model.terms.get_interactions(config);
end

function expected = get_expected(instance)
    expected = load(['data/expected/normalize_output_',instance,'.mat']);
end