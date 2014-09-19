function excitation = apply_excitation(data, color_interactions, config)
% Apply color filter to get interactions between color channels.
    if ~config.zli.interaction.color.enabled
        excitation = data;
    else
        % TODO can/should we use use fft?
        color_model  = config.zli.interaction.color.model;
        color_filter = color_interactions.excitation_filter;
        switch color_model
            case 'default'
                % A color channel excites all others
                data_padded       = model.data.padding.add.color(data, color_interactions, config);
                excitation_padded = model.data.convolutions.optimal(data_padded, color_filter);
                excitation        = model.data.padding.remove.color(excitation_padded, color_interactions, config);
            case 'opponent'
                % A color channel excites all except it's opponent
                excitation = apply_opponent_filter(data, color_filter, config);
            otherwise
                error('Unrecognized color interaction model: %s', color_model);
        end
    end
end

function excitation = apply_opponent_filter(data, filter, config)
% Activity in any color channel excites all others, except its opponent.
    n_channels = config.image.n_channels;
    excitation = zeros(size(data));
    for channel=1:n_channels
        temp     = get_temp(data, channel);
        center   = n_channels / 2;
        % TODO can/should we use use fft?
        filtered = model.data.convolutions.optimal(temp, filter);
        excitation(:,:,channel,:,:) = filtered(:,:,center,:,:);
    end
end

function temp = get_temp(data, channel)
% Returns a reformatted matrix with the channel to be excited in the
% center, and its opponent removed.
    temp     = data;
    center   = size(temp, 3) / 2;
    % Remove the opponent channel, it isn't to be excited
    opponent = get_opponent_index(channel);
    temp(:,:,opponent,:,:) = [];
    % If the main channel moved, update it's index
    if opponent < channel
        channel = channel - 1;
    end
    % Put the channel being excited in the center
    distance = center - channel;
    temp = circshift(temp, [0 0 distance 0 0]);
end

function opponent = get_opponent_index(channel)
    if model.data.utils.is_odd(channel)
        opponent = channel + 1;
    else
        opponent = channel - 1;
    end
end