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
    [ON_in, OFF_in] = model.data.signal.on_off(Iitheta, config);

    % Positius +++++++++++++++++++++++++++++++++++++++++++++++++++
    logger.log('Starting ON processing', config);
    ON_out  = model.process_induction(ON_in, config);
    
    % Negatius ----------------------------------------------------
    logger.log('Starting OFF processing', config);
    OFF_out = model.process_induction(OFF_in, config);

    Iitheta_final = combine_ON_OFF(ON_in, OFF_in, ON_out, OFF_out, config);
end

function Iitheta_final = process_ON_OFF_opponent(Iitheta, config)
%PROCESS_ON_OFF_OPPONENT Process the ON and OFF channels as opponents.
%   We take the input data as and split the ON and OFF information of each
%   color channel into independent color channels, which excite/inhibit
%   each other.
    
    n_membr    = config.zli.n_membr;
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    
    n_on_off_channels = n_channels*2;
    on_off_odds       = 1:2:n_on_off_channels;
    on_off_evens      = 2:2:n_on_off_channels;
    
    [ON_in, OFF_in] = model.data.signal.on_off(Iitheta, config);
    ON_OFF_in       = cell(n_membr, 1);
    [ON_OFF_in{:}]  = deal(zeros(n_cols, n_rows, n_on_off_channels, n_scales, n_orients)) ;
    for t=1:n_membr
        ON_OFF_in{t}(:,:,on_off_odds,:,:)  = ON_in{t};
        ON_OFF_in{t}(:,:,on_off_evens,:,:) = OFF_in{t};
    end
    
    % EEK! this isn't right..
    config.image.n_channels = n_on_off_channels;
    
    logger.log('Starting ON OFF opponency processing', config);
    ON_OFF_out = model.process_induction(ON_OFF_in, config);
    
    config.image.n_channels = n_channels;
    
    ON_out  = cell(n_membr, 1);
    OFF_out = cell(n_membr, 1);
    for t=1:n_membr
    ON_out{t}  = ON_OFF_out{t}(:,:,on_off_odds,:,:);
    OFF_out{t} = ON_OFF_out{t}(:,:,on_off_evens,:,:);
    end
    
    Iitheta_final = combine_ON_OFF(ON_in, OFF_in, ON_out, OFF_out, config);
end

function final = combine_ON_OFF(ON_in, OFF_in, ON_out, OFF_out, config)
    n_membr   = config.zli.n_membr;
    ON_final  = cell(n_membr, 1);
    OFF_final = cell(n_membr, 1);
    final     = cell(n_membr, 1);
    iFactor = ON_out;
    for t=1:n_membr
        ON_final{t}  =  ON_in{t}   .* ON_out{t}  * config.zli.normal_output;
        OFF_final{t} = -OFF_in{t}  .* OFF_out{t} * config.zli.normal_output;
        iFactor{t}   =  ON_out{t}   + OFF_out{t};
        final{t}     =  ON_final{t} + OFF_final{t};
    end
end