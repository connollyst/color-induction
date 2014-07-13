function psi_delta_theta = get_psi_delta_theta(config)
% Orientation interaction weights
    n_orients = config.wave.n_orients;
    switch n_orients
        case 3
            % Based on Z. Li 1999, p209
            a               = pi/4;
            b               = pi/2;
            delta_theta     = [0 a b; a 0 a ; b a 0];
            psi_delta_theta = cos(abs(delta_theta)).^6;
        case 1
            % Non-directional 
            psi_delta_theta = 1;
        otherwise
            error('Orientations not supported: %i', n_orients)
    end
end
