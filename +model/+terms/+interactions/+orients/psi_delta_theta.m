function pdt = psi_delta_theta(config)
% Orientation interaction weights
    n_orients = config.wave.n_orients;
    switch n_orients
        case 1
            % Non-directional single opponent cells
            pdt = 1;
        case 3
            % Oriented double opponent cells
            % Based on Z. Li 1999, p209
            a               = pi/4;
            b               = pi/2;
            delta_theta     = [0 a b; a 0 a ; b a 0];
            pdt = cos(abs(delta_theta)).^6;
        case 4
            % Both single and double opponent cells
            a               = pi/4;
            b               = pi/2;
            delta_theta     = [0 a b 1; a 0 a 1; b a 0 1; 0 0 0 1];
            pdt = cos(abs(delta_theta)).^6;
        otherwise
            error('Orientations not supported: %i', n_orients)
    end
end
