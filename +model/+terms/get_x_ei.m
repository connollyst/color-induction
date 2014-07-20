function x_ei = get_x_ei(gy_padded, interactions, config)
%GET_X_EI Calculate the excitatory-inhibitory term.
%   Input
%       gy_padded:      the gy input data, padded to avoid edge effects
%       interactions:   the struct of interaction parameters
%       config:         the struct of algorithm configuration parameters
%   Output
%       x_ei: excitatory-inhibitory term

    gy   = model.data.padding.remove(gy_padded, interactions.scale, config);
    x_ei = model.utils.zeros(config);
    
    for oc=1:config.wave.n_orients  % loop over the central (reference) orientation
        ei               = apply_scale_interactions(gy, interactions.scale, config);
        ei               = remove_extra_scales(ei, interactions.scale, config);
        ei               = apply_orient_interactions(ei, oc, interactions.orient, config);    
        x_ei(:,:,:,:,oc) = ei;
    end
end

function ei = apply_scale_interactions(gy, scale_interactions, config)
% Process interactions between scales..    
    if ~config.zli.interaction.scale.enabled
        ei = gy;
    else
        scale_filter        = scale_interactions.filter;
        avoid_circshift_fft = config.compute.avoid_circshift_fft;
        ei = model.data.convolutions.optima(gy, scale_filter, 0, 0, avoid_circshift_fft);
    end
end

function interaction = apply_orient_interactions(ei, center_orient, orient_interactions, config)
% Process interactions between orientations..
    if ~config.zli.interaction.scale.enabled
        interaction = sum(ei, 5);
    else
        PsiDtheta  = orient_interactions.PsiDtheta;
        n_cols     = config.image.width;
        n_rows     = config.image.height;
        n_channels = config.image.n_channels;
        n_scales   = config.wave.n_scales;
        n_orients  = config.wave.n_orients;

        orient_filter            = zeros(1,1,1,1,n_orients);
        orient_filter(1,1,1,1,:) = PsiDtheta(center_orient, :);
        orient_filter            = repmat(orient_filter, [n_cols, n_rows, n_channels, n_scales, 1]);
        interaction              = sum(ei .* orient_filter, 5);
    end
end

function ei_out = remove_extra_scales(ei_in, scale_interactions, config)
% Removes the extra scales that were added to facilitate the interaction
% convolution.
    scale_distance   = scale_interactions.distance;
    n_scales         = config.wave.n_scales;
    real_scale_range = scale_distance+1:scale_distance+n_scales;
    ei_out               = ei_in(:,:,:,real_scale_range,:);
end