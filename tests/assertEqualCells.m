function assertEqualCells(actual, expected)
    assertEqual(size(actual), size(expected), 'cell arrays should be the same size');
    for t=1:length(actual)
        for c=1:size(actual{t},3)
            for s=1:size(actual{t},4)
                for o=1:size(actual{t},5)
                    nextActual   = actual{t}(:,:,c,s,o);
                    nextExpected = expected{t}(:,:,c,s,o);
                    assertEqual(nextActual, nextExpected, ...
                        ['Expected same matrix at t=',num2str(t),', c=',num2str(c),', s=',num2str(s),', o=',num2str(o)] ...
                    );
                end
            end
        end
    end
end