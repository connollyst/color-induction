function test_suite = test_UpdateXY
%TEST_ADD_PADDING Test suite for convolutions.optima()
  initTestSuite;
end

function test_x_out_3D_t1_i01
    assert_x_out('3D_t1_i01')
end

function test_y_out_3D_t1_i01
    assert_y_out('3D_t1_i01')
end

function test_x_out_3D_t1_i02
    assert_x_out('3D_t1_i02')
end

function test_y_out_3D_t1_i02
    assert_y_out('3D_t1_i02')
end

function test_x_out_3D_t1_i10
    assert_x_out('3D_t1_i10')
end

function test_y_out_3D_t1_i10
    assert_y_out('3D_t1_i10')
end

function test_x_out_3D_t2_i01
    assert_x_out('3D_t2_i01')
end

function test_y_out_3D_t2_i01
    assert_y_out('3D_t2_i01')
end

function test_x_out_3D_t2_i02
    assert_x_out('3D_t2_i02')
end

function test_y_out_3D_t2_i02
    assert_y_out('3D_t2_i02')
end

function test_x_out_3D_t4_i01
    assert_x_out('3D_t4_i01')
end

function test_y_out_3D_t4_i01
    assert_y_out('3D_t4_i01')
end

%% ASSERTIONS

function assert_x_out(instance)
    [tIitheta, x, y, JW, norm_mask, interactions, config] = get_input(instance);
    [x_out, ~] = model.process.UpdateXY(tIitheta, x, y, JW, norm_mask, interactions, config);
    expected = get_expected(instance);
    assertEqual(x_out, expected.x_out);
end

function assert_y_out(instance)
    [tIitheta, x, y, JW, norm_mask, interactions, config] = get_input(instance);
    [~, y_out] = model.process.UpdateXY(tIitheta, x, y, JW, norm_mask, interactions, config);
    expected = get_expected(instance);
    assertEqual(y_out, expected.y_out);
end

%% TEST UTILITIES

function [tIitheta, x, y, JW, norm_mask, interactions, config] = get_input(instance)
    input        = load(['data/input/UpdateXY_',instance,'.mat']);
    tIitheta     = input.tIitheta;
    x            = input.x;
    y            = input.y;
    Delta        = input.Delta;
    JW           = input.JW;
    norm_mask    = input.norm_mask;
    interactions = input.interactions;
    config       = input.config;
    interactions.n_scale_interactions = 4; % TODO update config
    config.wave.scale_deltas = Delta;      % TODO use common config
end

function expected = get_expected(instance)
    expected = load(['data/expected/UpdateXY_',instance,'.mat']);
end