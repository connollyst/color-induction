function y_ie = get_y_ie(gx_padded, interactions, config)
%GET_X_EE_Y_IE Calculate the excitatory and inhibitory terms.
%   Input
%       gx_padded:      the gx input data, padded to avoid edge effects
%       JW:             the struct of J and W interaction data
%       interactions:   the struct of interaction parameters
%       config:         the struct of algorithm configuration parameters
%   Output
%       y_ie: excitatory-inhibitory term

    if config.zli.interaction.orient.enabled && config.compute.use_fft
        gx_padded = apply_fft(gx_padded);
    end
    
    y_ie = model.terms.interactions.orients.apply_inhibition(gx_padded, interactions.orient, interactions.scale, config);
    y_ie = model.terms.interactions.colors.apply_inhibition(y_ie, interactions.color, config);
    y_ie = model.terms.interactions.scales.apply_inhibition(y_ie, interactions.scale, config);
end

function gx_padded_fft = apply_fft(gx_padded)
% Preprocess the input data to Fourier space for faster convolutions.
    gx_padded_fft = cell(size(gx_padded));
    for s=1:length(gx_padded)
        gx_padded_fft{s} = zeros(size(gx_padded{s}));
        n_channels       = size(gx_padded{s}, 3);
        n_orients        = size(gx_padded{s}, 5);
        for c=1:n_channels
            for o=1:n_orients
                gx_padded_fft{s}(:,:,c,1,o) = fftn(gx_padded{s}(:,:,c,1,o));
            end
        end
    end
end