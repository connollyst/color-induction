function assertEqualCells(actual, expected)
    assertEqual(size(actual), size(expected), 'cell arrays should be the same size');
    for i=1:length(actual)
        assertEqualMatrices(actual{i}, expected{i})
    end
end