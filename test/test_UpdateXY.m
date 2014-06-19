function test_suite = test_UpdateXY
%TEST_ADD_PADDING Test suite for convolutions.optima()
  initTestSuite;
end

function test_x_out_01_01
    assert_x_out('01-01')
end

function test_y_out_01_01
    assert_y_out('01-01')
end

function test_x_out_01_02
    assert_x_out('01-02')
end

function test_y_out_01_02
    assert_y_out('01-02')
end

function test_x_out_02_10
    assert_x_out('02-10')
end

function test_y_out_02_10
    assert_y_out('02-10')
end

%% ASSERTIONS

function assert_x_out(instance)
    [tIitheta, x, y, Delta, JW, norm_mask, interactions, config] = get_input(instance);
    [x_out, ~] = model.process.UpdateXY(tIitheta, x, y, Delta, JW, norm_mask, interactions, config);
    expected = get_expected(instance);
    assertEqualMatrices(x_out, expected.x);
end

function assert_y_out(instance)
    [tIitheta, x, y, Delta, JW, norm_mask, interactions, config] = get_input(instance);
    [~, y_out] = model.process.UpdateXY(tIitheta, x, y, Delta, JW, norm_mask, interactions, config);
    expected = get_expected(instance);
    assertEqualMatrices(y_out, expected.y);
end

%% TEST UTILITIES

function [tIitheta, x, y, Delta, JW, norm_mask, interactions, config] = get_input(instance)
    input        = load(['data/input_to_UpdateXY_',instance,'.mat']);
    tIitheta     = addColorDimension(input.Iitheta{1}); % TODO get correct frame
    x            = addColorDimension(input.x);
    y            = addColorDimension(input.y);
    state        = load('data/state_UpdateXY.mat');
    Delta        = state.Delta;
    JW           = state.JW;
    norm_mask    = state.norm_mask;
    interactions = state.interactions;
    config       = state.config;
end

function expected = get_expected(instance)
    expected = load(['data/expected_from_UpdateXY_',instance,'.mat']);
end