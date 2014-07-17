function out = recover(ON_OFF_in, ON_OFF_out, config)
%RECOVER Summary of this function goes here
%   Detailed explanation goes here
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
    
    out = model.data.signal.on_off.separate.recover(ON_in, OFF_in, ON_out, OFF_out, config);
end

