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