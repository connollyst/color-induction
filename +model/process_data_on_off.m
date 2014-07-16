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
    [Iitheta_ON, Iitheta_OFF] = model.data.signal.on_off(Iitheta, config);

    % Positius +++++++++++++++++++++++++++++++++++++++++++++++++++
    logger.log('Starting ON processing', config);
    iFactor_ON  = model.process_induction(Iitheta_ON, config);
    
    % Negatius ----------------------------------------------------
    logger.log('Starting OFF processing', config);
    iFactor_OFF = model.process_induction(Iitheta_OFF, config);

    % Prepare output
    Iitheta_ON_final  = cell(size(Iitheta));
    Iitheta_OFF_final = cell(size(Iitheta));
    Iitheta_final     = cell(size(Iitheta));
    iFactor = iFactor_ON;
    for t=1:config.zli.n_membr
        Iitheta_ON_final{t}  =  Iitheta_ON{t}      .* iFactor_ON{t}  * config.zli.normal_output;
        Iitheta_OFF_final{t} = -Iitheta_OFF{t}     .* iFactor_OFF{t} * config.zli.normal_output;
        iFactor{t}           =  iFactor_ON{t}       + iFactor_OFF{t};
        Iitheta_final{t}     =  Iitheta_ON_final{t} + Iitheta_OFF_final{t};
    end
end

function Iitheta_final = process_ON_OFF_opponent(Iitheta, config)
%PROCESS_ON_OFF_OPPONENT Process the ON and OFF channels as opponents.
%   We take the input data as and split the ON and OFF information of each
%   color channel into independent color channels, which excite/inhibit
%   each other.
    
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    
    on_off_channels = n_channels*2;
    on_off_odds     = 1:2:on_off_channels;
    on_off_evens    = 2:2:on_off_channels;
    [Iitheta_ON, Iitheta_OFF] = model.data.signal.on_off(Iitheta, config);
    
    Iitheta_ON_OFF = cell(size(Iitheta));
    [Iitheta_ON_OFF{:}] = deal(zeros(n_cols, n_rows, n_channels*2, n_scales, n_orients)) ;
    for t=1:config.zli.n_membr
        Iitheta_ON_OFF{t}(:,:,on_off_odds,:,:)  = Iitheta_ON{t};
        Iitheta_ON_OFF{t}(:,:,on_off_evens,:,:) = Iitheta_OFF{t};
    end
    
    % TODO do something with Iitheta_ON_OFF
end

