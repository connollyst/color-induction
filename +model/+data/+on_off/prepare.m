function ON_OFF_in = prepare(wavelets_in, config)
%MODEL.DATA.ON_OFF.PREPARE
%   Preprocess the data to isolate/combine/separate the on & off signals.
%   Formulae:
%       on:         only take the on signal
%       off:        only take the off signal (output is positive)
%       abs:        take the absolute of both the on and off signal
%       square:     square the on and off signal in each channel
%       separate:   split the on and off signals into separate channels
    switch config.zli.ON_OFF
        case 'on'
            ON_OFF_in = prepare_on(wavelets_in);
        case 'off'
            ON_OFF_in = prepare_off(wavelets_in);
        case 'abs'
            ON_OFF_in = prepare_abs(wavelets_in);
        case 'square'
            ON_OFF_in = prepare_square(wavelets_in);
        case 'separate'
            ON_OFF_in = prepare_separately(wavelets_in);
        otherwise
            error('Invalid config.zli.ON_OFF: %s', config.zli.ON_OFF)
    end
end

function ON_OFF_in = prepare_on(wavelets_in)
    ON_OFF_in = model.data.utils.on(wavelets_in);
end

function ON_OFF_in = prepare_off(wavelets_in)
    ON_OFF_in = model.data.utils.off(wavelets_in);
end

function ON_OFF_in = prepare_abs(wavelets_in)
    ON_OFF_in = wavelets_in;
    for t=1:length(wavelets_in)
        ON_OFF_in{t} = abs(wavelets_in{t});
    end
end

function ON_OFF_in = prepare_square(wavelets_in)
    ON_OFF_in = wavelets_in;
    for t=1:length(wavelets_in)
        ON_OFF_in{t} = wavelets_in{t} .* wavelets_in{t};
    end
end

function ON_OFF_in = prepare_separately(wavelets_in)
    ON_OFF_in = model.data.on_off.separate.prepare(wavelets_in);
end