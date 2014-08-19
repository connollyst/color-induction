function I_out = prepare_output(ON_OFF_in, ON_OFF_out, residuals, config)
%PREPARE_OUTPUT Summary of this function goes here
%   Detailed explanation goes here
    if strcmp(config.zli.ON_OFF, 'separate')
        % TODO I don't like this.. =\
        config.image.n_channels = config.image.n_channels / 2;
    end
    wavelets_out = model.data.on_off.recover(ON_OFF_in, ON_OFF_out, config);
    O            = model.data.decomposition.invert(wavelets_out, residuals, config);
    I_out        = average_output(O, config);
end

function O = average_output(I, config)
    % We take the mean as the output, as in Li, 1999
    n_membr         = config.zli.n_membr;
    n_frames_promig = config.image.n_frames_promig;
    if n_frames_promig == 0
        n_frames_promig = n_membr - 1;
    end
    t_start         = n_membr - n_frames_promig + 1;
    t_end           = n_membr;
    I_dims          = ndims(I{1});
    I_flat          = cat(I_dims+1, I{t_start:t_end});
    O               = mean(I_flat, I_dims+1);
end