function pdt = psi_delta_theta(config)
% Orientation interaction weights
    n_orients = config.wave.n_orients;
    if n_orients == 3 || n_orients == 4
        % Based on Z. Li 1999, p209
        a               = pi/4;
        b               = pi/2;
        delta_theta     = [0 a b; a 0 a ; b a 0];
        pdt = cos(abs(delta_theta)).^6;
    else
        if n_orients == 1
            % Non-directional 
            pdt = 1;
        else
            error('Orientations not supported: %i', n_orients)
        end
    end
end
