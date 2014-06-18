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
    %imagesc(restr_newgy_toroidal_y(:,:));
    %waitforbuttonpress;
    [x_ee, x_ei, y_ie]                               = model.get_excitation_and_inhibition(newgx_toroidal_x, restr_newgy_toroidal_y, Delta, JW, interactions, config);
    %figure(1);
    %subplot(3,1,1); imagesc(x_ee(:,:));
    %subplot(3,1,2); imagesc(x_ei(:,:));
    %subplot(3,1,3); imagesc(y_ie(:,:));
    %waitforbuttonpress;
    I_norm                                           = normalize(norm_mask, newgx_toroidal_x, interactions, config);
    %imagesc(I_norm(:,:));
    %waitforbuttonpress;
    [x_out, y_out]                                   = calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config);
    %figure(1);
    %subplot(2,1,1); imagesc(x_out(:,:));
    %subplot(2,1,2); imagesc(y_out(:,:));
    %waitforbuttonpress;
    
    
    figure(1);
    subplot(7,1,1); imagesc(restr_newgy_toroidal_y(:,:));
    subplot(7,1,2); imagesc(x_ee(:,:));
    subplot(7,1,3); imagesc(x_ei(:,:));
    subplot(7,1,4); imagesc(y_ie(:,:));
    subplot(7,1,5); imagesc(I_norm(:,:));
    subplot(7,1,6); imagesc(x_out(:,:));
    subplot(7,1,7); imagesc(y_out(:,:));
    %drawnow
    waitforbuttonpress;
end

function I_norm = normalize(norm_mask, newgx_toroidal_x, interactions, config)
%NORMALIZE
%   We generalize Z.Li's formula for the normalization by suming over all
%   the scales within a given hypercolumn (cf. p209, where she already sums
%   over all the orientations)

    n_cols              = config.image.width;
    n_rows              = config.image.height;
    n_channels          = config.image.n_channels;
    n_scales            = config.wave.n_scales;
    n_orients           = config.wave.n_orients;
    avoid_circshift_fft = config.compute.avoid_circshift_fft;
    r                   = config.zli.normalization_power;
    inv_den             = norm_mask.inv_den;
    M_norm_conv         = norm_mask.M_norm_conv;
    M_norm_conv_fft     = norm_mask.M_norm_conv_fft;
    scale_distance      = interactions.scale_distance;
    Delta_ext           = interactions.Delta_ext;
    
    I_norm = zeros(n_cols, n_rows, n_channels, n_scales, n_orients);
    for c=1:n_channels
        for s=scale_distance+1:scale_distance+n_scales
            s2 = s - scale_distance;
            radi=(size(M_norm_conv{s2})-1)/2;
            % sum over all the orientations
            sum_newgx_toroidal_x_sc = sum(newgx_toroidal_x{s}, 5);
            despl = radi;
            kk = convolutions.optima( ...
                sum_newgx_toroidal_x_sc( ...
                    Delta_ext(s) + 1 - radi(1) : Delta_ext(s) + n_cols + radi(1), ...
                    Delta_ext(s) + 1 - radi(2) : Delta_ext(s) + n_rows + radi(2) ...
                ), ...
                M_norm_conv_fft{s2}, despl, 1, avoid_circshift_fft ...
            ); % Xavier. El filtre diria que ha d'estar normalitzat per tal de calcular el valor mig
            kk_cols = radi(1) + 1 : n_cols + radi(1);
            kk_rows = radi(2) + 1 : n_rows + radi(2);
            I_norm_s2 = repmat(kk(kk_cols, kk_rows), [1 1 n_orients]);
            I_norm(:, :, c, s2, :) = I_norm_s2;
        end
    end
    for s=1:n_scales  % times roughly 50 if the flag is 1
        I_norm(:,:,:,s,:) = -2 * (I_norm(:,:,:,s,:) * inv_den{s}) .^ r;
    end
end

function [x, y] = calculate_xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config)
%CALCULATE_XY Formulas (1) and (2) p.192, Li 1999
%   Calculate the next excitatory (x) and inhibitory (y) membrane
%   potentials.
    
    prec = 1/config.zli.n_iter;
    
    % (1) inhibitory neurons
    y = y + prec * (...
            - config.zli.alphay * y...                  % decay
            + model.terms.newgx(x)...                   % TODO why not x_ee?
            + y_ie...
            + 1.0...                                    % spontaneous firing rate
            + model.terms.noise(config)...              % neural noise (comment for speed)
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
            + model.terms.noise(config)...              % neural noise (comment for speed)
        );
end