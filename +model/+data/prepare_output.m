function [out, I_out] = prepare_output(wavelets_in, activity_out, residuals, config)
%PREPARE_OUTPUT Summarizes the raw output.
%   The excitatory output from each membrane time step is averaged for
%   interpretation. A 'perceptual image' is also generate by overlaying
%   this activity on the input image components and inverting the
%   decomposition.
%   Note that this 'perceptual image' _may_ be useful in interpreting the
%   raw output but is probably meaningless. The direction of the neuronal
%   activity is much more directly indicitive of what the model is doing.
    if strcmp(config.zli.ON_OFF, 'separate')
        % TODO I don't like this =\
        config.image.n_channels = config.image.n_channels / 2;
    end
    % Summarize the activity from each time step..
    out          = average_raw_output(activity_out, config);
    % Recover a perceptual image..
    wavelets_out = model.data.on_off.recover(wavelets_in, activity_out, config);
    O            = model.data.decomposition.invert(wavelets_out, residuals, config);
    I_out        = average_output(O, config);
end

function out = average_raw_output(activity_out, config)
    out_avg = average_output(activity_out, config);
    out     = sum(sum(out_avg, 5), 4);
    if strcmp(config.zli.ON_OFF, 'separate')
        n_channels = size(out, 3);
        odds       = 1:2:n_channels;
        evens      = 2:2:n_channels;
        out        = out(:,:,odds) - out(:,:,evens);
    end
end

function O = average_output(I, config)
% We take the mean as the output, as in Li, 1999
    steps  = get_steps_to_average(config);
    I_dims = ndims(I{1});
    I_flat = cat(I_dims+1, I{steps});
    O      = mean(I_flat, I_dims+1);
end

function steps = get_steps_to_average(config)
    n_membr  = config.zli.n_membr;
    n_frames = config.image.n_frames_promig;
    if n_frames == 0
        n_frames = n_membr - 1;
    end
    t_start  = n_membr - n_frames + 1;
    t_end    = n_membr;
    steps    = t_start:t_end;
end