function excitation = apply_excitation(data, color_interactions, config)
% Apply color filter to get interactions between color channels.
    if ~config.zli.interaction.color.enabled
        excitation = data;
    else
        % TODO can/should we use use fft?
        filter = color_interactions.excitation_filter;
        switch config.zli.ON_OFF
            case 'separate'
                excitation = apply_opponent_filter(data, filter, config);
            otherwise
                % Activity in any color channel excites all others
                data_padded       = model.data.padding.add.color(data, color_interactions, config);
                excitation_padded = model.data.convolutions.optimal(data_padded, filter);
                excitation        = model.data.padding.remove.color(excitation_padded, color_interactions, config);
        end
    end
end

function excitation = apply_opponent_filter(data, filter, config)
% Activity in any opponent color channel excites all others
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
    opponent = get_opponent_index(channel);
    temp     = data;
    center   = size(temp, 3) / 2;
    % Remove the opponent channel, it isn't to be excited
    temp(:,:,opponent,:,:) = [];
    % Put the channel being excited in the center
    if channel < center || channel == center+1
        temp(:,:,[channel, center],:,:)   = temp(:,:,[center, channel],:,:);
    else
        temp(:,:,[channel-1, center],:,:) = temp(:,:,[center, channel-1],:,:);
    end
end

function opponent = get_opponent_index(channel)
    if model.data.utils.is_odd(channel)
        opponent = channel + 1;
    else
        opponent = channel - 1;
    end
end