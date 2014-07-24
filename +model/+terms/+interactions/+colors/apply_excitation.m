function excitation = apply_excitation(data, color_interactions, config)
% Apply color filter to get interactions between color channels.
    if ~config.zli.interaction.color.enabled
        excitation = data;
    else
        % Activity in any opponent color channel excites all others
        % TODO can/should we use use fft?
        data_padded       = model.data.padding.add.color(data, color_interactions, config);
        excitation_padded = model.data.convolutions.optima( ...
                                data_padded, color_interactions.excitation_filter, 0, 0 ...
                            );
        excitation        = model.data.padding.remove.color( ...
                                excitation_padded, color_interactions, config ...
                            );
    end
end