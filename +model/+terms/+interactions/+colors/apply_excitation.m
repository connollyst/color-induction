function excitation = apply_excitation(data, color_interactions, config)
% Apply color filter to get interactions between color channels.
    if ~config.zli.interaction.color.enabled
        excitation = data;
    else
        % Activity in any opponent color channel excites all others
        % TODO can/should we use use fft?
        excitation = model.data.convolutions.optima( ...
                        data, color_interactions.excitation_filter, 0, 0 ...
                     );
    end
end