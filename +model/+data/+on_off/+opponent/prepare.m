function ON_OFF = prepare(I, config)
%MODEL.DATA.ON_OFF.OPPONENT.PREPARE
%   Prepare the input data for opponent ON OFF signal processing.
%   The positive (ON) and negative (OFF) values for each channel are
%   separated into their own channels. The ON and OFF channels are
%   organized next to each other, ON first, OFF second.
%   
%   For example, consider an input (I) with 3 channels: A, B, & C
%       ON_OFF = prepare(I, config);
%       ON_OFF(:,:,1) >> A ON
%       ON_OFF(:,:,2) >> A OFF
%       ON_OFF(:,:,3) >> B ON
%       ON_OFF(:,:,4) >> B OFF
%       ON_OFF(:,:,5) >> C ON
%       ON_OFF(:,:,6) >> C OFF

    n_membr           = config.zli.n_membr;
    n_cols            = config.image.width;
    n_rows            = config.image.height;
    n_channels        = config.image.n_channels;
    n_scales          = config.wave.n_scales;
    n_orients         = config.wave.n_orients;
    
    n_on_off_channels = n_channels * 2;
    on_off_odds       = 1:2:n_on_off_channels;
    on_off_evens      = 2:2:n_on_off_channels;
    
    [ON, OFF]   = model.data.on_off.separate.prepare(I, config);
    
    ON_OFF      = cell(n_membr, 1);
    [ON_OFF{:}] = deal(zeros(n_cols, n_rows, n_on_off_channels, n_scales, n_orients)) ;
    for t=1:n_membr
        ON_OFF{t}(:,:,on_off_odds,:,:)  = ON{t};
        ON_OFF{t}(:,:,on_off_evens,:,:) = OFF{t};
    end
end

