function assertEqualCells(actual, expected, config)
    assertEqual(size(actual), size(expected), 'cell arrays should be the same size');
    n_channels = config.image.n_channels;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    n_membr    = config.zli.n_membr;
    for t=1:n_membr
        for c=1:n_channels
            for s=1:n_scales
                for o=1:n_orients
                    nextActual   = actual{t}(:,:,c,s,o);
                    nextExpected = expected{t}(:,:,c,s,o);
                    assertEqual(nextActual, nextExpected, ...
                        ['Expected same response at t=',num2str(t),', c=',num2str(c),', s=',num2str(s),', o=',num2str(o)] ...
                    );
                end
            end
        end
    end
end