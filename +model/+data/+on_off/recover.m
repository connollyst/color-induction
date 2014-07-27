function data_out = recover(data_in, signal_out, config)
%PROCESS_DATA_ON_OFF Separate ON and OFF channels and start
%   recovering the response at the level of the wavelet/Gabor responses.
    switch config.zli.ON_OFF
        case 'abs'
            data_out = model.data.on_off.simple.recover(data_in, signal_out, config);
        case 'square'
            data_out = model.data.on_off.simple.recover(data_in, signal_out, config);
        case 'separate'
            data_out = model.data.on_off.opponent.recover(data_in, signal_out, config);
        otherwise
            error('Invalid config.zli.ON_OFF: %s', config.zli.ON_OFF)
    end
end