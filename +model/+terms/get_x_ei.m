function x_ei = get_x_ei(gy_padded, interactions, config)
%GET_X_EI Calculate the excitatory-inhibitory term.
%   Input
%       gy_padded:      the gy input data, padded to avoid edge effects
%       interactions:   the struct of interaction parameters
%       config:         the struct of algorithm configuration parameters
%   Output
%       x_ei: excitatory-inhibitory term

    % TODO it's sloppy that we don't get the data how we want it
    gy   = restructure_data(gy_padded, interactions.scale, config);
    x_ei = model.utils.zeros(config);
    
    for oc=1:config.wave.n_orients  % loop over the central (reference) orientation
        ei               = apply_scale_interactions(gy, interactions.scale, config);
        ei               = apply_orient_interactions(ei, oc, interactions.orient, config);    
        ei               = apply_color_interactions(ei, interactions.color, config);
        x_ei(:,:,:,:,oc) = ei;
    end
end

function center = restructure_data(padded, scale_interactions, config)
%RESTRUCTURE_DATA Extract the centers of the padded image.
%   TODO why pad the image in the first place??
    center = model.utils.zeros(config); % TODO doesn't account for extra scales
    for s=1:scale_interactions.n_interactions
        center(:,:,:,s,:) = extract_center(padded, s, scale_interactions, config);
    end
end

function center = extract_center(padded, s, scale_interactions, config)
%EXTRACT_CENTER Recovers the original from the center of the padded image.
%   Note: the padded data is in a struct array, while the recovered centers
%         are returned in a matrix.
    n_cols    = config.image.width;
    n_rows    = config.image.height;
    Delta_ext = scale_interactions.Delta_ext;
    
    cols   = Delta_ext(s)+1 : Delta_ext(s)+n_cols;
    rows   = Delta_ext(s)+1 : Delta_ext(s)+n_rows;
    center = padded{s}(cols, rows, :, :);
end

function ei = apply_scale_interactions(gy, scale_interactions, config)
% Process interactions between scales..    
    if ~config.zli.interaction.scale.enabled
        ei = gy;
    else
        scale_filter        = scale_interactions.filter;
        avoid_circshift_fft = config.compute.avoid_circshift_fft;
        ei = model.data.convolutions.optima(gy, scale_filter, 0, 0, avoid_circshift_fft);
        ei = remove_extra_scales(ei, scale_interactions, config);
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

function ei = apply_orient_interactions(ei, center_orient, orient_interactions, config)
% Process interactions between orientations..
    if ~config.zli.interaction.scale.enabled
        ei = sum(ei, 5);
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
        ei                       = sum(ei .* orient_filter, 5);
    end
end

function ei = apply_color_interactions(ei, color_interactions, config)
    % TODO what kind of interactions do we want?
end