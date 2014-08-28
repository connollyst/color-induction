function color_filter = excitation_filter(config)
%MODEL.TERMS.INTERACTIONS.COLORS.EXCITATION_FILTER 
%   Returns the excitatory color interaction filter appropriate for the
%   given config.
    if ~config.zli.interaction.color.enabled
        color_filter = model.terms.interactions.filter_nothing();
    else
       if ~model.data.utils.is_even(config.image.n_channels)
           error('MODEL:uneven_opponent', ['Opponent color ' ...
               'interactions require an even number of color channels.'])
       end
        % OPPONENT COLOR EXCITATION FILTER:
        % In an opponent color system, non-opponent channels excite
        % each other equally.
        filter_size     = config.image.n_channels - 1;
        opponent_weight = config.zli.interaction.color.weight.excitation;
        color_filter    = model.terms.interactions.filter_equally(...
                                filter_size, opponent_weight ...
                          );
    end
end