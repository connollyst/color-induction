function assertEqualData(actual, expected)
    if iscell(actual)
        assertEqualDataCells(actual, expected)
    else
        assertEqualDataMatrices(actual, expected)
    end
end

function assertEqualDataCells(actual, expected)
    assertEqual(size(actual), size(expected), 'cell arrays should be the same size');
    for t=1:length(actual)
        assertEqualDataMatrices(actual{t}, expected{t})
    end
end

function assertEqualDataMatrices(actual, expected)
    for c=1:size(actual, 3)
        for s=1:size(actual, 4)
            for o=1:size(actual, 5)
                nextActual   = actual(:,:,c,s,o);
                nextExpected = expected(:,:,c,s,o);
                assertEqual(nextActual, nextExpected, ...
                    ['Expected same matrix at c=',num2str(c),', s=',num2str(s),', o=',num2str(o)] ...
                );
            end
        end
    end
end