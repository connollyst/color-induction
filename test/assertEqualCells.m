function assertEqualCells(actual, expected)
    assertEqual(size(actual), size(expected));
    for i=1:length(actual)
        assertEqualMatricies(actual{i}, expected{i})
    end
end