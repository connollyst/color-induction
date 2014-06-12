function [x_out, y_out] = UpdateXY(tIitheta, x, y, Delta, JW, norm_mask, interactions, config)
%UPDATEXY Update the excitatiory (x) and inhibitory (y) membrane potentials
%   tIitheta:       Cell array of new input stimulus.
%   x:              The current excitatory membrane potentials.
%   y:              The current inhibitory membrane potentials.
%   Delta:          ???
%   JW:             The excitation (J) and inhibition (W) connection masks.
%   norm_mask:      Normalized interaction mask. (TODO part of interactions?)
%   interactions:   Structure array defining the neuronal interactions.
%   config:         Structure array of general application configurations.
%
%   x_out:          The new excitatory membrane potentials.
%   y_out:          The new inhibitory membrane potentials.

    % TODO there must be better names??
    [newgx_toroidal_x, ~, ~, restr_newgy_toroidal_y] = model.add_padding(x, y, Delta, interactions, config);
    [x_ee, x_ei, y_ie]                               = get_excitation_and_inhibition(newgx_toroidal_x, restr_newgy_toroidal_y, Delta, JW, interactions, config);
    I_norm                                           = normalize(norm_mask, newgx_toroidal_x, interactions, config);
    [x_out, y_out]                                   = calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
end

function [x_ee, x_ei, y_ie] = get_excitation_and_inhibition(newgx_toroidal_x, restr_newgy_toroidal_y, Delta, JW, interactions, config)
%GET_EXCITATION_AND_INHIBITION

    % Orientation/Scale Interactions
    half_size_filter    = interactions.half_size_filter;
    scale_distance      = interactions.scale_distance;
    scale_filter        = interactions.scale_filter;
    PsiDtheta           = interactions.PsiDtheta;
    % Equaltion Parameters
    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    % Computation Configurations
    use_fft             = config.compute.use_fft;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    
    x_ee   = zeros(n_cols, n_rows, n_scales, n_orients);
    x_ei   = zeros(n_cols, n_rows, n_scales, n_orients);
    y_ie   = zeros(n_cols, n_rows, n_scales, n_orients);

    %%%%%%%%%%%%%% preparatory terms %%%%%%%%%%%%%%%%%%%%%%%%%%
    if use_fft
        newgx_toroidal_x_fft = cell(scale_distance+n_scales,1);
        for s=1:n_scales
            newgx_toroidal_x_fft{scale_distance+s}=cell(n_orients,1);
            for ov=1:n_orients  % loop over all the orientations given the central (reference orientation)
                newgx_toroidal_x_fft{scale_distance+s}{ov} = fftn(newgx_toroidal_x{scale_distance+s}(:,:,ov));
            end
        end
    end

    for oc=1:n_orients  % loop over the central (reference) orientation
        % excitatory-inhibitory term (no existia):   x_ei
        % influence of the neighboring scales first

        sum_scale_newgy_toroidal_y = convolutions.optima(restr_newgy_toroidal_y,scale_filter,0,0,avoid_circshift_fft); % does it give the right dimension? 'same' needed?
        restr_sum_scale_newgy_toroidal_y = sum_scale_newgy_toroidal_y(:,:,scale_distance+1:scale_distance+n_scales,:); % restriction over scales
        w = zeros(1,1,1,n_orients);w(1,1,1,:)=PsiDtheta(oc,:);
        x_ei(:,:,:,oc) = sum(restr_sum_scale_newgy_toroidal_y.*repmat(w,[n_cols,n_rows,n_scales,1]),4);

        % excitatory and inhibitory terms (the big sums)
        % excitatory-excitatory term:    x_ee
        % excitatory-inhibitory term:    y_ie

        x_ee_conv_tmp = zeros(n_cols, n_rows, n_scales, n_orients);
        y_ie_conv_tmp = zeros(n_cols, n_rows, n_scales, n_orients);

        for ov=1:n_orients  % loop over all the orientations given the central (reference orientation)
            % FFT
            if use_fft
                for s=1:n_scales
                    kk=convolutions.optima_fft(newgx_toroidal_x_fft{scale_distance+s}{ov},JW.J_fft{s}(:,:,1,ov,oc),half_size_filter{s},1,avoid_circshift_fft);
                    x_ee_conv_tmp(:,:,s,ov)=kk(Delta(s)+1:Delta(s)+n_cols,Delta(s)+1:Delta(s)+n_rows);
                    kk=convolutions.optima_fft(newgx_toroidal_x_fft{scale_distance+s}{ov},JW.W_fft{s}(:,:,1,ov,oc),half_size_filter{s},1,avoid_circshift_fft);
                    y_ie_conv_tmp(:,:,s,ov)=kk(Delta(s)+1:Delta(s)+n_cols,Delta(s)+1:Delta(s)+n_rows);
                end
            else
                error('Non FFT approach is not implemented.');
            end
        end
        x_ee(:,:,:,oc) = sum(x_ee_conv_tmp, 4);
        y_ie(:,:,:,oc) = sum(y_ie_conv_tmp, 4);
    end   % of the loop over the central (reference) orientation
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % influence of the neighboring spatial frequencies
    x_ee = convolutions.optima(x_ee, scale_filter, 0, 0);
    y_ie = convolutions.optima(y_ie, scale_filter, 0, 0);
    % TODO why not x_ei?
end

function I_norm = normalize(norm_mask, newgx_toroidal_x, interactions, config)
%NORMALIZE
%   We generalize Z.Li's formula for the normalization by suming over all
%   the scales within a given hypercolumn (cf. p209, where she already sums
%   over all the orientations)

    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    r                   = config.zli.normalization_power; % normalization (I_norm)
    inv_den             = norm_mask.inv_den;
    M_norm_conv         = norm_mask.M_norm_conv;
    M_norm_conv_fft     = norm_mask.M_norm_conv_fft;
    scale_distance      = interactions.scale_distance;
    Delta_ext           = interactions.Delta_ext;
    
    I_norm = zeros(n_cols, n_rows, n_scales, n_orients);
    for s=scale_distance+1:scale_distance+n_scales
        radi=(size(M_norm_conv{s-scale_distance})-1)/2;
        % sum over all the orientations
        sum_newgx_toroidal_x_sc = sum(newgx_toroidal_x{s}, 4);
        despl = radi;
        kk = convolutions.optima( ...
            sum_newgx_toroidal_x_sc( ...
                Delta_ext(s) + 1 - radi(1) : Delta_ext(s) + n_cols + radi(1), ...
                Delta_ext(s) + 1 - radi(2) : Delta_ext(s) + n_rows + radi(2) ...
            ), ...
            M_norm_conv_fft{s-scale_distance}, despl, 1, avoid_circshift_fft ...
        ); % Xavier. El filtre diria que ha d'estar normalitzat per tal de calcular el valor mig
        I_norm(:, :, s-scale_distance, :) = repmat( ...
            kk(radi(1) + 1 : n_cols + radi(1), radi(2) + 1 : n_rows + radi(2)),...
            [1 1 n_orients] ...
        );
    end
    for s=1:n_scales  % times roughly 50 if the flag is 1
        I_norm(:,:,s,:) = -2 * (I_norm(:,:,s,:) * inv_den{s}) .^ r;
    end
end

function [x, y] = calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config)
%CALCULATE_XY Formulas (1) and (2) p.192, Li 1999
%   Calculate the next excitatory (x) and inhibitory (y) membrane
%   potentials.

    % TEMP!!!
    % We've restructured x and y, this rebuilds the old structure so we can
    % understand what was being done in this function..
    x        = temp.new_to_old(x);          % DELETEME!!
    y        = temp.new_to_old(y);          % DELETEME!!
    tIitheta = temp.new_to_old(tIitheta);   % DELETEME!!
    
    prec = 1/config.zli.n_iter;
    
    % (1) inhibitory neurons
    y = y + prec * (...
            - config.zli.alphay * y...                  % decay
            + model.terms.newgx(x)...                   % TODO why not x_ee?
            + y_ie...
            + 1.0...                                    % spontaneous firing rate
            + generate_noise(config)...                 % neural noise (comment for speed)
        );
    % (2) excitatory neurons
    x = x + prec * (...
            - config.zli.alphax * x...				    % decay
            - x_ei...					                % ei term
            + config.zli.J0 * model.terms.newgx(x)...   % input
            + x_ee...
            + tIitheta...                               % Iitheta at time t
            + I_norm...                                 % normalization
            + 0.85...                                   % spontaneous firing rate
            + generate_noise(config)...                 % neural noise (comment for speed)
        );
    
    x = temp.old_to_new(x); % DELETEME!!
    y = temp.old_to_new(y); % DELETEME!!
end

function noise = generate_noise(config)
%GENERATE_NOISE Generate neural noise.
    n_cols     = config.image.width;
    n_rows     = config.image.height;
    n_channels = config.image.n_channels;   % TODO reshape noise to include channels
    n_scales   = config.wave.n_scales;
    n_orients  = config.wave.n_orients;
    var_noise  = 0.1 * 2;
    noise      = var_noise * (rand(n_cols, n_rows, n_scales, n_orients)) - 0.5;
end