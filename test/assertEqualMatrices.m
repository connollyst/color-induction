function assertEqualMatrices(actual, expected)
    expected = addColorDimension(expected);
    assertEqual(actual, expected);
end