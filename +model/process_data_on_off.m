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
        Iitheta_final{t} = Iitheta{t} .* iFactor{t} * zli.normal_output;
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
        Iitheta_final{t} = Iitheta{t} .* iFactor{t} * zli.normal_output;
    end
end

function Iitheta_final = process_ON_OFF_separately(Iitheta, config)
%PROCESS_ON_OFF_SEPARATELY Process the ON and OFF channels independently.

    n_membr  = config.zli.n_membr;
    
    % Initialize data structures
    Iitheta_ON        = Iitheta;
    Iitheta_OFF       = Iitheta;
    Iitheta_ON_final  = Iitheta;
    Iitheta_OFF_final = Iitheta;
    Iitheta_final     = cell(size(Iitheta));

    % Calculate the ON/OFF signals
    for t=1:n_membr
        index_OFF                =  Iitheta{t} <= 0;
        index_ON                 =  Iitheta{t} >= 0;
        Iitheta_ON{t}            =  Iitheta{t};
        Iitheta_OFF{t}           = -Iitheta{t};
        Iitheta_ON{t}(index_OFF) = 0;
        Iitheta_OFF{t}(index_ON) = 0;
    end

    % Positius +++++++++++++++++++++++++++++++++++++++++++++++++++
    logger.log('Starting ON processing', config);
    iFactor_ON  = model.process_induction(Iitheta_ON, config);
    
    % Negatius ----------------------------------------------------
    logger.log('Starting OFF processing', config);
    iFactor_OFF = model.process_induction(Iitheta_OFF, config);

    % Prepare output
    iFactor = iFactor_ON;
    for t=1:n_membr
        Iitheta_ON_final{t}  =  Iitheta_ON{t}      .* iFactor_ON{t}  * config.zli.normal_output;
        Iitheta_OFF_final{t} = -Iitheta_OFF{t}     .* iFactor_OFF{t} * config.zli.normal_output;
        iFactor{t}           =  iFactor_ON{t}       + iFactor_OFF{t};
        Iitheta_final{t}     =  Iitheta_ON_final{t} + Iitheta_OFF_final{t};
    end
end