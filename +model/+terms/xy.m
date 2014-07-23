function [x, y] = xy(tIitheta, I_norm, x, y, x_ee, x_ei, y_ie, config)
%MODEL.TERMS.GET_XY Formulas (1) and (2) p.192, Li 1999
%   Calculate the next excitatory (x) and inhibitory (y) membrane
%   potentials.
    
    prec = 1/config.zli.n_iter;
    
    % (1) inhibitory neurons
    y = y + prec * (...
            - config.zli.alphay * y...                  % decay
            + model.terms.gx(x)...
            + y_ie...
            + model.terms.Ic(config) ...
        );
    % (2) excitatory neurons
    x = x + prec * (...
            - config.zli.alphax * x...				    % decay
            - x_ei...					                % ei term
            + config.zli.J0 * model.terms.gx(x)...      % input
            + x_ee...
            + tIitheta...                               % visual input at time t
            + model.terms.Io(I_norm, config) ...
        );
end