function assertEqualCells(actual, expected)
    assertEqual(size(actual), size(expected));
    for i=1:length(actual)
        assertEqualMatrices(actual{i}, expected{i})
    end
end