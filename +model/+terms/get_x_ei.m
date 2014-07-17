function x_ei = get_x_ei(gy_padded, interactions, config)
%GET_X_EI Calculate the excitatory-inhibitory term.
%   Input
%       gy_padded:      the gy input data, padded to avoid edge effects
%       interactions:   the struct of interaction parameters
%       config:         the struct of algorithm configuration parameters
%   Output
%       x_ei: excitatory-inhibitory term

    n_cols       = config.image.width;
    n_rows       = config.image.height;
    n_channels   = config.image.n_channels;
    n_scales     = config.wave.n_scales;
    n_orients    = config.wave.n_orients;
    
    x_ei = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    
    for oc=1:n_orients  % loop over the central (reference) orientation
        x_ei_scales         = x_ei_scale_interactions(gy_padded, interactions.scale, config);
        x_ei_scales_orients = x_ei_orient_interactions(x_ei_scales, oc, interactions.orient, config);    
        x_ei(:,:,:,:,oc)    = x_ei_scales_orients;
    end
end

function x_ei_scales = x_ei_scale_interactions(gy_padded, scale_interactions, config)
% Process interactions between scales..

    scale_distance      = scale_interactions.distance;
    scale_filter        = scale_interactions.filter;
    n_scales            = config.wave.n_scales;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    
    gy               = model.data.padding.remove(gy_padded, scale_interactions, config);
    gy_filtered      = model.data.convolutions.optima(gy, scale_filter, 0, 0, avoid_circshift_fft);
    real_scale_range = scale_distance+1:scale_distance+n_scales;
    x_ei_scales      = gy_filtered(:,:,:,real_scale_range,:); % remove 'interaction scales'
end

function x_ei_scales_orients = x_ei_orient_interactions(x_ei_scales, center_orient, orient_interactions, config)
% Process interactions between orientations..

    PsiDtheta  = orient_interactions.PsiDtheta;
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    
    orient_filter            = zeros(1,1,1,1,n_orients);
    orient_filter(1,1,1,1,:) = PsiDtheta(center_orient, :);
    orient_filter            = repmat(orient_filter, [n_cols, n_rows, n_channels, n_scales, 1]);
    x_ei_scales_orients      = sum(x_ei_scales .* orient_filter, 5);
end