function out = recover(ON_OFF_in, ON_OFF_out, config)
%MODEL.DATA.ON_OFF.SEPARATE.RECOVER
%   Recover the output data given the opponent ON and OFF activity.
    n_membr    = config.zli.n_membr;
    n_channels = config.image.n_channels;
    
    n_on_off_channels = n_channels*2;
    on_off_odds       = 1:2:n_on_off_channels;
    on_off_evens      = 2:2:n_on_off_channels;
    
    ON_in   = cell(n_membr, 1);
    OFF_in  = cell(n_membr, 1);
    ON_out  = cell(n_membr, 1);
    OFF_out = cell(n_membr, 1);
    for t=1:n_membr
        ON_in{t}   = ON_OFF_in{t}(:,:,on_off_odds,:,:);
        OFF_in{t}  = ON_OFF_in{t}(:,:,on_off_evens,:,:);
        ON_out{t}  = ON_OFF_out{t}(:,:,on_off_odds,:,:);
        OFF_out{t} = ON_OFF_out{t}(:,:,on_off_evens,:,:);
    end
    
    out = combine(ON_in, OFF_in, ON_out, OFF_out, config);
end

function final = combine(ON_in, OFF_in, ON_out, OFF_out, config)
% Recover the output data given the separate ON and OFF activity.
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