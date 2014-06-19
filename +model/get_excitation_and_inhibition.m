function [x_ee, x_ei, y_ie] = get_excitation_and_inhibition(newgx_toroidal_x, restr_newgy_toroidal_y, Delta, JW, interactions, config)
%GET_EXCITATION_AND_INHIBITION

    % Orientation/Scale Interactions
    scale_filter        = interactions.scale_filter;
    % Equaltion Parameters
    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    
    x_ee = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    x_ei = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    y_ie = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);

    newgx_toroidal_x_fft = get_preparatory_term(newgx_toroidal_x, interactions, config);

    % influence of the neighboring scales first
    for oc=1:n_orients  % loop over the central (reference) orientation
        x_ei(:,:,:,:,oc) = get_x_ei(oc, restr_newgy_toroidal_y, interactions, config);
        % TODO returned matrices lack color dimension
        [x_ee_conv_tmp, y_ie_conv_tmp] = get_x_ee_y_ie(oc, newgx_toroidal_x_fft, Delta, JW, interactions, config);
        x_ee(:,:,:,:,oc) = sum(x_ee_conv_tmp, 4);
        y_ie(:,:,:,:,oc) = sum(y_ie_conv_tmp, 4);
    end
    
    % influence of the neighboring spatial frequencies
    x_ee = convolutions.optima(x_ee, scale_filter, 0, 0);
    y_ie = convolutions.optima(y_ie, scale_filter, 0, 0);
end

function newgx_toroidal_x_fft = get_preparatory_term(newgx_toroidal_x, interactions, config)
% Prepare the input data for processing

    % Orientation/Scale Interactions
    scale_distance = interactions.scale_distance;
    % Equaltion Parameters
    n_scales       = config.wave.n_scales;
    n_orients      = config.wave.n_orients;
    % Computation Configurations
    use_fft        = config.compute.use_fft;
    
    if use_fft
        newgx_toroidal_x_fft = cell(scale_distance+n_scales, 1);
        for s=1:n_scales
            newgx_toroidal_x_fft{scale_distance+s} = cell(n_orients, 1);
            for ov=1:n_orients  % loop over all the orientations given the central (reference orientation)
                newgx_toroidal_x_fft{scale_distance+s}{ov} = fftn(newgx_toroidal_x{scale_distance+s}(:,:,ov));
            end
        end
    else
        error('Non FFT approach is not implemented.');
    end
end

function x_ei = get_x_ei(oc, restr_newgy_toroidal_y, interactions, config)
% Excitatory-inhibitory term (no existia): x_ei

    % Orientation/Scale Interactions
    scale_distance      = interactions.scale_distance;
    scale_filter        = interactions.scale_filter;
    % Equaltion Parameters
    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    % Computation Configurations
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    
    sum_scale_newgy_toroidal_y = convolutions.optima(restr_newgy_toroidal_y,scale_filter,0,0,avoid_circshift_fft); % does it give the right dimension? 'same' needed?
    restr_sum_scale_newgy_toroidal_y = sum_scale_newgy_toroidal_y(:,:,:,scale_distance+1:scale_distance+n_scales,:); % restriction over scales
    w = zeros(1,1,1,1,n_orients); w(1,1,1,1,:) = interactions.PsiDtheta(oc,:);
    x_ei = sum(restr_sum_scale_newgy_toroidal_y .* repmat(w,[n_cols,n_rows,n_channels,n_scales,1]), 5);
end

function [x_ee_conv_tmp, y_ie_conv_tmp] = get_x_ee_y_ie(oc, newgx_toroidal_x_fft, Delta, JW, interactions, config)
% Excitatory and inhibitory terms (the big sums)
% excitatory-excitatory term:    x_ee
% excitatory-inhibitory term:    y_ie
        
    % Orientation/Scale Interactions
    half_size_filter    = interactions.half_size_filter;
    scale_distance      = interactions.scale_distance;
    % Equaltion Parameters
    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    % Computation Configurations
    use_fft             = config.compute.use_fft;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    
    x_ee_conv_tmp = zeros(n_cols, n_rows, n_scales, n_orients);
    y_ie_conv_tmp = zeros(n_cols, n_rows, n_scales, n_orients);
    for ov=1:n_orients  % loop over all the orientations given the central (reference orientation)
        % FFT
        if use_fft
            for s=1:n_scales
                cols     = Delta(s)+1:Delta(s)+n_cols;
                rows     = Delta(s)+1:Delta(s)+n_rows;
                J_fft_s  = JW.J_fft{s}(:,:,1,ov,oc);
                W_fft_s  = JW.W_fft{s}(:,:,1,ov,oc);
                s_filter = half_size_filter{s};
                x_fft    = newgx_toroidal_x_fft{scale_distance+s}{ov};
                x_fft_J  = convolutions.optima_fft(x_fft, J_fft_s, s_filter, 1, avoid_circshift_fft);
                x_fft_W  = convolutions.optima_fft(x_fft, W_fft_s, s_filter, 1, avoid_circshift_fft);
                x_ee_conv_tmp(:,:,s,ov) = x_fft_J(cols, rows);
                y_ie_conv_tmp(:,:,s,ov) = x_fft_W(cols, rows);
            end
        else
            error('Non FFT approach is not implemented.');
        end
    end
end