function ON_OFF_in = prepare(wavelets_in, config)
%MODEL.DATA.ON_OFF.PREPARE Prepare the ON OFF aspect of the data.
    switch config.zli.ON_OFF
        case 'abs'
            ON_OFF_in = process_ON_OFF_abs(wavelets_in, config);
        case 'square'
            ON_OFF_in = process_ON_OFF_square(wavelets_in, config);
        case 'separate'
            ON_OFF_in = process_ON_OFF_separately(wavelets_in, config);
        otherwise
            error('Invalid config.zli.ON_OFF: %s', config.zli.ON_OFF)
    end
end

function ON_OFF_in = process_ON_OFF_abs(Iitheta, config)
%PROCESS_ON_OFF_ABS Process the ON and OFF channels using absolute values.
    ON_OFF_in = Iitheta;
    for t=1:config.zli.n_membr
        ON_OFF_in{t} = abs(Iitheta{t});
    end
end

function ON_OFF_in = process_ON_OFF_square(Iitheta, config)
%PROCESS_ON_OFF_SQUARE Process the ON and OFF components using square
    ON_OFF_in = Iitheta;
    for t=1:config.zli.n_membr
        ON_OFF_in{t} = Iitheta{t}.*Iitheta{t};
    end
end

function ON_OFF_in = process_ON_OFF_separately(Iitheta, config)
%PROCESS_ON_OFF_SEPARATELY Process ON and OFF as independent channels.
%   We take the input data as and split the ON and OFF components of each
%   color channel into independent color channels. If color interactions
%   are disabled, the ON and OFF components do not interact.
    ON_OFF_in = model.data.on_off.separate.prepare(Iitheta, config);
    % TODO this is migrated from PROCESS_ON_OFF_OPPONENT, I don't think
    %      it makes sense, depends on what we mean by ON and OFF..?
end