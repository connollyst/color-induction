function curv_final = NCZLd_channel_ON_OFF_v1_1(curv, config)
%NCZLd_CHANNEL_ON_OFF_V1_1 Separate ON and OFF channels and start
%   recovering thye response at the level of the wavelet/Gabor responses.
% 
    
    % Number of scales
    % TODO this is super sloppy..
    config.wave.n_scales = config.wave.fin_scale;
    
    % choose the algorithm (separated, abs, quadratic) 
    switch config.zli.ON_OFF
        case 0 % Separated
            curv_final = process_ON_OFF_separately(curv, config);
        case 1 % ABS
            curv_final = process_ON_OFF_abs(curv, config);
        case 2 % Square (quadratic)
            curv_final = process_ON_OFF_square(curv, config);
    end
end

function curv_final = process_ON_OFF_separately(curv, config)
%PROCESS_ON_OFF_SEPARATELY Process the ON and OFF channels independently.

    n_membr  = config.zli.n_membr;
    
    %% Initialize data structures
    curv_ON        = curv;
    curv_OFF       = curv;
    curv_ON_final  = curv;
    curv_OFF_final = curv;
    curv_final     = cell(size(curv));

    %% Calculate the ON/OFF signals
    for t=1:n_membr
        index_OFF             = curv{t} <= 0;
        index_ON              = curv{t} >= 0;
        curv_ON{t}            =  curv{t};
        curv_OFF{t}           = -curv{t};
        curv_ON{t}(index_OFF) = 0;
        curv_OFF{t}(index_ON) = 0;
    end

    %% Positius +++++++++++++++++++++++++++++++++++++++++++++++++++
    disp('Starting ON processing');
    % TODO we should have an iFactor for each dimension!!
    iFactor_ON  = model.process.Rmodelinductiond_v0_3_2(curv_ON, config);

    %% Negatius ----------------------------------------------------
    disp('Starting OFF processing');
    iFactor_OFF = model.process.Rmodelinductiond_v0_3_2(curv_OFF, config);

    %% Prepare output
    iFactor = iFactor_ON;
    for t=1:n_membr
        curv_ON_final{t}  =  curv_ON{t}     .* iFactor_ON{t}  * config.zli.normal_output;
        curv_OFF_final{t} = -curv_OFF{t}    .* iFactor_OFF{t} * config.zli.normal_output;
        iFactor{t}        = iFactor_ON{t}    + iFactor_OFF{t};
        curv_final{t}     = curv_ON_final{t} + curv_OFF_final{t};
    end
end

function [curv_final] = process_ON_OFF_abs(curv, config)
%PROCESS_ON_OFF_ABS Process the ON and OFF channels using absolute values.
%   Note: This has not been updated since Sean's refactoring of the data
%         structure. Anyway, from looking at the code, it never worked in
%         the first place; it doesn't return the ON/OFF data.
    dades = curv;
    for t=1:n_membr
        dades{t} = abs(curv{t});
    end

    iFactor = Rmodelinductiond_v0_3_2(dades, config);

    for t=1:n_membr
        curv_final{t} = curv{t} .* iFactor{t} * zli.normal_output;
    end
end

function [curv_final] = process_ON_OFF_square(curv, config)
%PROCESS_ON_OFF_SQUARE Process the ON and OFF channels using square
%   Note: This has not been updated since Sean's refactoring of the data
%         structure. Anyway, from looking at the code, it never worked in
%         the first place; it doesn't return the ON/OFF data.
    dades = curv;
    for t=1:n_membr
        dades{t} = curv{t}.*curv{t};
    end
    iFactor = Rmodelinductiond_v0_3_2(dades, config);
    for t=1:n_membr
        curv_final{t} = curv{t} .* iFactor{t} * zli.normal_output;
    end
end
