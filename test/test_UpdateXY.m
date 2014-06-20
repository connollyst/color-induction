function test_suite = test_UpdateXY
%TEST_ADD_PADDING Test suite for convolutions.optima()
  initTestSuite;
end

function test_x_out_1D_t01_i01
    assert_x_out('01-01')
end

function test_y_out_1D_t01_i01
    assert_y_out('01-01')
end

function test_x_out_1D_t01_i02
    assert_x_out('01-02')
end

function test_y_out_1D_t01_i02
    assert_y_out('01-02')
end

function test_x_out_1D_t02_i10
    assert_x_out('02-10')
end

function test_y_out_1D_t02_i10
    assert_y_out('02-10')
end

function test_x_out_3D_t01_i01
    % Get input
    input        = load('data/input_to_UpdateXY_3D_t01_i01.mat');
    tIitheta     = input.tIitheta;
    x            = input.x;
    y            = input.y;
    Delta        = input.Delta;
    JW           = input.JW;
    norm_mask    = input.norm_mask;
    interactions = input.interactions;
    config       = input.config;
    % Get expected results
    expected_x_1 = get_expected_x('3D_t01_i01_a');
    expected_x_2 = get_expected_x('3D_t01_i01_b');
    expected_x_3 = get_expected_x('3D_t01_i01_c');
    expected_x   = zeros(size(x));
    expected_x(:,:,1,:,:) = expected_x_1;
    expected_x(:,:,2,:,:) = expected_x_2;
    expected_x(:,:,3,:,:) = expected_x_3;
    % Run UpdateXY
    [x_out, ~] = model.process.UpdateXY(tIitheta, x, y, Delta, JW, norm_mask, interactions, config);
    % Compare results
    for c=1:size(x, 3)
        for s=1:size(x, 4)
            for o=1:size(x, 5)
                assertEqual(x_out(:,:,c,s,o), expected_x(:,:,c,s,o), ...
                    ['Matrices not equals at c=',num2str(c),' s=',num2str(s),' o=',num2str(o),' (at least)'] ...
                );
            end
        end
    end
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

function expected_x = get_expected_x(instance)
    expected = load(['data/expected_from_UpdateXY_',instance,'.mat']);
    expected_x = expected.x;
end