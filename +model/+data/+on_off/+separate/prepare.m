function ON_OFF = prepare(I)
%MODEL.DATA.ON_OFF.SEPARATE.PREPARE
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

    n_membr           = length(I);
    n_cols            = size(I{1}, 1);
    n_rows            = size(I{1}, 2);
    n_channels        = size(I{1}, 3);
    n_scales          = size(I{1}, 4);
    n_orients         = size(I{1}, 5);
    
    n_on_off_channels = n_channels * 2;
    on_off_odds       = 1:2:n_on_off_channels;
    on_off_evens      = 2:2:n_on_off_channels;
    
    [ON, OFF]   = separate(I);
    
    ON_OFF      = cell(n_membr, 1);
    [ON_OFF{:}] = deal(zeros(n_cols, n_rows, n_on_off_channels, n_scales, n_orients)) ;
    for t=1:n_membr
        ON_OFF{t}(:,:,on_off_odds,:,:)  = ON{t};
        ON_OFF{t}(:,:,on_off_evens,:,:) = OFF{t};
    end
end

function [ON, OFF] = separate(I)
% Prepare the input data for separate ON OFF signal processing.
    [ON, OFF] = deal(cell(size(I)));
    for t=1:length(I)
        index_OFF        =  I{t} <= 0;
        index_ON         =  I{t} >= 0;
        ON{t}            =  I{t};
        OFF{t}           = -I{t};
        ON{t}(index_OFF) = 0;
        OFF{t}(index_ON) = 0;
    end
end