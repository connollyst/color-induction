function test_suite = test_normalize_output
%TEST_ADD_PADDING Test suite for model.normalize_output()
  initTestSuite;
end

function test_I_norm_01
    assert_I_norm('01')
end

%% ASSERTIONS

function assert_I_norm(instance)
    % TODO get input
    [norm_mask, newgx_toroidal_x, interactions, config] = get_input(instance);
    I_norm   = model.normalize_output(norm_mask, newgx_toroidal_x, interactions, config);
    expected = get_expected(instance);
    assertEqualMatricies(I_norm, expected.I_norm);
end

%% TEST UTILITIES

function [norm_mask, newgx_toroidal_x, interactions, config] = get_input(instance)
    input            = load(['data/input_to_normalize_output_',instance,'.mat']);
    newgx_toroidal_x = addColorDimension(input.newgx_toroidal_x);
    state            = load('data/state_UpdateXY.mat');
    norm_mask        = state.norm_mask;
    interactions     = state.interactions;
    config           = state.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_normalize_output_',instance,'.mat']);
end