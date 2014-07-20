function inhibition = apply_inhibition(data, color_interactions, config)
% Apply color filter to get interactions between color channels.
    if ~config.zli.interaction.color.enabled
        inhibition = data;
    else
        switch config.zli.interaction.color.scheme
            case 'default'
                % No inter-color inhibition
                inhibition = data;
            case 'opponent'
                % Only opponent colors inhibit each other
                inhibition   = model.utils.zeros(config);
                color_filter = color_interactions.inhibition_filter;
                for i=1:2:config.image.n_channels
                    on  = i;
                    off = i+1;
                    inhibition(:,:,[on off],:,:) = ...
                        model.data.convolutions.optima( ...
                            data(:,:,[on off],:,:), color_filter, 0, 0 ...
                        );
                end
                if config.display.plot >= 2
                    figure(2); title('Inhibition');
                    subplot(2,1,1); imagesc(data(:,:)); title('before');
                    subplot(2,1,2); imagesc(inhibition(:,:)); title('after');
                    waitforbuttonpress();
                end
            otherwise
                error('Invalid: config.zli.interaction.color.scheme=%s',...
                                config.zli.interaction.color.scheme)
        end
    end
end