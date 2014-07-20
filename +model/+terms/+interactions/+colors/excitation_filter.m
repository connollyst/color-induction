function color_filter = excitation_filter(config)
%MODEL.TERMS.INTERACTIONS.COLORS.EXCITATION_FILTER 
%   Returns the excitatory color interaction filter appropriate for the
%   given config.
    if ~config.zli.interaction.color.enabled
        color_filter = model.terms.interactions.filter_nothing();
    else
        switch config.zli.interaction.color.scheme
            case 'default'
                % DEFAULT COLOR EXCITATION FILTER:
                % Each color excites all other colors equally.
                % Note: for no interaction, turn off config.zli.interaction.color.enabled
                weight       = config.zli.interaction.color.weight;
                color_filter = model.terms.interactions.filter_equally(...
                                        config.image.n_channels, ...
                                        weight ...
                               );
            case 'opponent'
                if ~model.data.utils.is_even(config.image.n_channels)
                    error('MODEL:config', ['Opponent color interactions ', ...
                        'require an even number of color channels.'])
                end
                % OPPONENT COLOR EXCITATION FILTER:
                % In an opponent color system, non-opponent channels excite
                % each other equally. However, this is applied in a
                % pairwise fashion, so we don't need a large filter like
                % 'filter_equally'.
                self_weight     = 1;
                opponent_weight = config.zli.interaction.color.weight.excitation;
                color_filter    = model.terms.interactions.filter_neighbors(...
                                        self_weight, opponent_weight ...
                                  );
            otherwise
                error('Invalid: config.zli.interaction.color.scheme=%s',...
                                config.zli.interaction.color.scheme)
        end
    end
end