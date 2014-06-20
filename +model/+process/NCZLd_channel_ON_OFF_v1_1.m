function Iitheta_final = NCZLd_channel_ON_OFF_v1_1(Iitheta, config)
%NCZLd_CHANNEL_ON_OFF_V1_1 Separate ON and OFF channels and start
%   recovering the response at the level of the wavelet/Gabor responses.
    switch config.zli.ON_OFF
        case 0 % Separated
            Iitheta_final = process_ON_OFF_separately(Iitheta, config);
        case 1 % ABS
            Iitheta_final = process_ON_OFF_abs(Iitheta, config);
        case 2 % Square (quadratic)
            Iitheta_final = process_ON_OFF_square(Iitheta, config);
    end
end

function Iitheta_final = process_ON_OFF_separately(Iitheta, config)
%PROCESS_ON_OFF_SEPARATELY Process the ON and OFF channels independently.

    n_membr  = config.zli.n_membr;
    
    %% Initialize data structures
    Iitheta_ON        = Iitheta;
    Iitheta_OFF       = Iitheta;
    Iitheta_ON_final  = Iitheta;
    Iitheta_OFF_final = Iitheta;
    Iitheta_final     = cell(size(Iitheta));

    %% Calculate the ON/OFF signals
    for t=1:n_membr
        index_OFF                = Iitheta{t} <= 0;
        index_ON                 = Iitheta{t} >= 0;
        Iitheta_ON{t}            =  Iitheta{t};
        Iitheta_OFF{t}           = -Iitheta{t};
        Iitheta_ON{t}(index_OFF) = 0;
        Iitheta_OFF{t}(index_ON) = 0;
    end

    %% Positius +++++++++++++++++++++++++++++++++++++++++++++++++++
    disp('Starting ON processing');
    % TODO we should have an iFactor for each dimension!!
    iFactor_ON  = model.process.Rmodelinductiond_v0_3_2(Iitheta_ON, config);

    %% Negatius ----------------------------------------------------
    disp('Starting OFF processing');
    iFactor_OFF = model.process.Rmodelinductiond_v0_3_2(Iitheta_OFF, config);

    %% Prepare output
    iFactor = iFactor_ON;
    for t=1:n_membr
        Iitheta_ON_final{t}  =  Iitheta_ON{t}      .* iFactor_ON{t}  * config.zli.normal_output;
        Iitheta_OFF_final{t} = -Iitheta_OFF{t}     .* iFactor_OFF{t} * config.zli.normal_output;
        iFactor{t}           =  iFactor_ON{t}       + iFactor_OFF{t};
        Iitheta_final{t}     =  Iitheta_ON_final{t} + Iitheta_OFF_final{t};
    end
end

function [Iitheta_final] = process_ON_OFF_abs(Iitheta, config)
%PROCESS_ON_OFF_ABS Process the ON and OFF channels using absolute values.
%   Note: This has not been updated since Sean's refactoring of the data
%         structure. Anyway, from looking at the code, it never worked in
%         the first place; it doesn't return the ON/OFF data.
    dades = Iitheta;
    for t=1:n_membr
        dades{t} = abs(Iitheta{t});
    end

    iFactor = Rmodelinductiond_v0_3_2(dades, config);

    for t=1:n_membr
        Iitheta_final{t} = Iitheta{t} .* iFactor{t} * zli.normal_output;
    end
end

function [Iitheta_final] = process_ON_OFF_square(Iitheta, config)
%PROCESS_ON_OFF_SQUARE Process the ON and OFF channels using square
%   Note: This has not been updated since Sean's refactoring of the data
%         structure. Anyway, from looking at the code, it never worked in
%         the first place; it doesn't return the ON/OFF data.
    dades = Iitheta;
    for t=1:n_membr
        dades{t} = Iitheta{t}.*Iitheta{t};
    end
    iFactor = Rmodelinductiond_v0_3_2(dades, config);
    for t=1:n_membr
        Iitheta_final{t} = Iitheta{t} .* iFactor{t} * zli.normal_output;
    end
end
