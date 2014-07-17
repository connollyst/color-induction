function Iitheta_final = process_data_on_off(Iitheta, config)
%PROCESS_DATA_ON_OFF Separate ON and OFF channels and start
%   recovering the response at the level of the wavelet/Gabor responses.
    switch config.zli.ON_OFF
        case 'abs'
            Iitheta_final = process_ON_OFF_abs(Iitheta, config);
        case 'square'
            Iitheta_final = process_ON_OFF_square(Iitheta, config);
        case 'separate'
            Iitheta_final = process_ON_OFF_separately(Iitheta, config);
        case 'opponent'
            Iitheta_final = process_ON_OFF_opponent(Iitheta, config);
        otherwise
            error('Invalid config.zli.ON_OFF: %s', config.zli.ON_OFF)
    end
end

function Iitheta_final = process_ON_OFF_abs(Iitheta, config)
%PROCESS_ON_OFF_ABS Process the ON and OFF channels using absolute values.
    n_membr       = config.zli.n_membr;
    Iitheta_final = cell(n_membr, 1);
    data          = Iitheta;
    for t=1:n_membr
        data{t} = abs(Iitheta{t});
    end
    iFactor = model.process_induction(data, config);
    for t=1:n_membr
        Iitheta_final{t} = Iitheta{t} .* iFactor{t} * config.zli.normal_output;
    end
end

function Iitheta_final = process_ON_OFF_square(Iitheta, config)
%PROCESS_ON_OFF_SQUARE Process the ON and OFF channels using square
    n_membr       = config.zli.n_membr;
    Iitheta_final = cell(n_membr, 1);
    data          = Iitheta;
    for t=1:n_membr
        data{t} = Iitheta{t}.*Iitheta{t};
    end
    iFactor = model.process_induction(data, config);
    for t=1:n_membr
        Iitheta_final{t} = Iitheta{t} .* iFactor{t} * config.zli.normal_output;
    end
end

function Iitheta_final = process_ON_OFF_separately(Iitheta, config)
%PROCESS_ON_OFF_SEPARATELY Process the ON and OFF channels independently.
    
    % Calculate the ON/OFF signals
    [ON_in, OFF_in] = model.data.signal.on_off.separate.prepare(Iitheta, config);

    % Positius +++++++++++++++++++++++++++++++++++++++++++++++++++
    logger.log('Starting ON processing', config);
    ON_out  = model.process_induction(ON_in, config);
    
    % Negatius ----------------------------------------------------
    logger.log('Starting OFF processing', config);
    OFF_out = model.process_induction(OFF_in, config);

    Iitheta_final = model.data.signal.on_off.separate.recover(ON_in, OFF_in, ON_out, OFF_out, config);
end

function Iitheta_out = process_ON_OFF_opponent(Iitheta, config)
%PROCESS_ON_OFF_OPPONENT Process the ON and OFF channels as opponents.
%   We take the input data as and split the ON and OFF information of each
%   color channel into independent color channels, which excite/inhibit
%   each other.
    
    logger.log('Starting ON OFF opponency processing', config);
    n_channels = config.image.n_channels;
    
    ON_OFF_in = model.data.signal.on_off.opponent.prepare(Iitheta, config);
    config.image.n_channels = n_channels*2; % EEK! this isn't right..?!
    
    ON_OFF_out = model.process_induction(ON_OFF_in, config);
    config.image.n_channels = n_channels;
    
    Iitheta_out = model.data.signal.on_off.opponent.recover(ON_OFF_in, ON_OFF_out, config);
end