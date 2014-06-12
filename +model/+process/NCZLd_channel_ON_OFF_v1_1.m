function [curv_final_out, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF] = ...
                                                NCZLd_channel_ON_OFF_v1_1(curv_in, config)
%NCZLd_CHANNEL_ON_OFF_V1_1 Separate ON and OFF channels and start
%   recovering thye response at the level of the wavelet/Gabor responses.
% 

    % preallocate
    % TODO I don't like this, we should preallocate with zeros
    curv_final_out = curv_in;

    %-------------------------------------------------------
    display_plot  = config.display_plot;
    n_membr       = config.zli.n_membr;
    ON_OFF        = config.zli.ON_OFF;
    fin_scale     = config.wave.fin_scale;
    n_orients      = config.wave.n_orients;
    plot_wavelet_planes = display_plot.plot_wavelet_planes;
    %-------------------------------------------------------

    % TODO is this necessary? Is MATLAB pass by reference or value?
    curv = curv_in;
    
    % Number of scales
    % TODO this is super sloppy..
    config.wave.n_scales = fin_scale;
    
    % choose the algorithm (separated, abs, quadratic) 
    switch(ON_OFF)
        case 0 % Separated
            [curv_final, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF] = ...
                process_ON_OFF_separately(curv, config);
        case 1 % ABS
            [curv_final] = process_ON_OFF_abs(curv, config);
        case 2 % Square (quadratic)
            [curv_final] = process_ON_OFF_square(curv, config);
    end

    for t=1:n_membr
        for s=1:fin_scale
            for o=1:n_orients
                % TODO can we just assign, without the loops?
                curv_final_out{o,s,t} = curv_final{o,s,t}(:,:,:);
            end
        end
    end

    % save raw values for all
    if config.display_plot.store == 1
        write_data(curv, curv_final, ...
            curv_ON, curv_OFF, curv_ON_final, curv_OFF_final, ...
            iFactor_ON, iFactor_OFF, iFactor, ...
            config ...
        );
    end

    % display for debuging
    if plot_wavelet_planes == 1
        figure;
        subplot(1,3,1), imagesc(curv{orient, scale, n_iter});       colormap('gray');
        subplot(1,3,2), imagesc(iFactor(:,:,n_iter), [0 1]);        colormap('gray');
        subplot(1,3,3), imagesc(curv_final{orient, scale, n_iter}); colormap('gray');
    end

end


function [curv_final, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF] = process_ON_OFF_separately(curv, config)
%PROCESS_ON_OFF_SEPARATELY Process the ON and OFF channels independently.

    n_membr        = config.zli.n_membr;
    fin_scale      = config.wave.fin_scale;
    n_orients      = config.wave.n_orients;
    
    %% Initialize data structures
    index_ON       = cell(n_orients, fin_scale, n_membr);
    index_OFF      = cell(n_orients, fin_scale, n_membr);
    curv_ON        = curv;
    curv_OFF       = curv;
    curv_ON_final  = curv;
    curv_OFF_final = curv;
    curv_final     = curv;	 

    %% Calculate the ON/OFF signals
    for t=1:n_membr
        for s=1:fin_scale
            for o=1:n_orients
                % TODO we don't need to store the indices outside this loop
                index_OFF{o,s,t} = find(curv{o,s,t} <= 0);
                index_ON{o,s,t}  = find(curv{o,s,t} >= 0);
                curv_ON{o,s,t}   =  curv{o,s,t};
                curv_OFF{o,s,t}  = -curv{o,s,t};
                curv_OFF{o,s,t}(index_ON{o,s,t}) = 0;
                curv_ON{o,s,t}(index_OFF{o,s,t}) = 0;
            end
        end
    end

    %% Positius +++++++++++++++++++++++++++++++++++++++++++++++++++
    disp('Starting ON processing');
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

function write_data(curv, curv_final, curv_ON, curv_OFF, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF, iFactor, config)
    image = config.image;
    save([image.name '_curv'],'curv');
    save([image.name '_curv_final'],'curv_final');
    switch(ON_OFF)
        case 0
            save([image.name '_curv_ON'],'curv_ON');
            save([image.name '_curv_OFF'],'curv_OFF');
            save([image.name '_curv_ON_final'],'curv_ON_final');
            save([image.name '_curv_OFF_final'],'curv_OFF_final');
            save([image.name '_iFactor_ON'],'iFactor_ON');
            save([image.name '_iFactor_OFF'],'iFactor_OFF');
            save([image.name '_iFactor'],'iFactor');
        case 1
            save([image.name '_iFactor'],'iFactor');
        case 2
            save([image.name '_iFactor'],'iFactor');
    end
end