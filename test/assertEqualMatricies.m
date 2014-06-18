function assertEqualMatricies(actual, expected)
    expected = addColorDimension(expected);
    assertEqual(actual, expected);
end