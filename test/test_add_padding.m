function test_add_padding
%TEST_ADD_PADDING Run the test suites for model.add_padding()
    state = load('data/UpdateXY_config_interactions.mat');
    
    input = load('data/add_padding_input_01.mat');
    x = addColorDimension(input.x);
    y = addColorDimension(input.y);
    
    [newgx_toroidal_x, newgy_toroidal_y, restr_newgx_toroidal_x, restr_newgy_toroidal_y] = ...
        model.add_padding(x, y, input.Delta, state.interactions, state.config);
    expected = load('data/add_padding_output_01.mat');
    assertEqualCells(newgx_toroidal_x, expected.newgx_toroidal_x);
    assertEqualCells(newgy_toroidal_y, expected.newgy_toroidal_y);
    assertEqualMatrix(restr_newgx_toroidal_x, expected.restr_newgx_toroidal_x);
    assertEqualMatrix(restr_newgy_toroidal_y, expected.restr_newgy_toroidal_y);
end

function assertEqualCells(actual, expected)
    assertEqual(size(actual), size(expected));
    for i=1:length(actual)
        assertEqualMatrix(actual{i}, expected{i})
    end
end

function assertEqualMatrix(actual, expected)
    expected = addColorDimension(expected);
    assertEqual(actual, expected);
end

function O = addColorDimension(I)
    c = size(I, 1);
    r = size(I, 2);
    s = size(I, 3);
    o = size(I, 4);
    O = zeros(c, r, 1, s, o);
    O(:,:,1,:,:) = I;
end