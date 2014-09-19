function pdt = psi_delta_theta(config)
% Orientation interaction weights
    n_orients = config.wave.n_orients;
    switch n_orients
        case 1
            % Non-directional single opponent cells
            pdt = 1;
        case 3
            % Oriented double opponent cells
            pdt = psi_delta_theta_pi();
        case 4
            % Both single and double opponent cells
            pdt = psi_delta_theta_pi();
            c = config.zli.interaction.orient.to_so;
            d = config.zli.interaction.orient.from_so;
            pdt = [pdt, [d d d]'];
            pdt = [pdt;  c c c 1];
        otherwise
            error('Orientations not supported: %i', n_orients)
    end
end

function pdt = psi_delta_theta_pi
% Based on Z. Li 1999, p209
    a = pi/4;
    b = pi/2;
    pdt = [0 a b; ...
           a 0 a; ...
           b a 0];
    pdt = cos(abs(pdt)).^6;
end